//
//  BluetoothManager.swift
//  Perform
//
//  Created by Haven Barnes on 11/14/16.
//  Copyright © 2016 ___FULLUSERNAME__. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreData

/**
 BlutoothManager handles all BLE communication and data parsing
 */
class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    
    static let shared = BluetoothManager()
    
    var peripheralManager: CBPeripheralManager?
    
    override init() {
        super.init()
        
        let options = [CBCentralManagerOptionShowPowerAlertKey: false]
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        peripheralManager?.delegate = self
    }
    
    func start() {
        if peripheralManager != nil && !peripheralManager!.isAdvertising {
            startAdvertising(peripheralManager)
        }
    }
    
    func stop() {
        peripheralManager?.stopAdvertising()
    }
    
    // MARK: - Core Bluetooth Delegate Functions
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            print("BLE Powered Off")
            break
        case .poweredOn:
            print("BLE Powered On")
            break
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(advertisementData)
        if advertisementData[CBAdvertisementDataLocalNameKey] != nil {
            if let profileIdData = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                guard profileIdData.contains("bed_bugs_") else { return }
                let id = profileIdData.replacingOccurrences(of: "bed_bugs_", with: "")
                print(id)
                
            }
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            print("BLE Powered Off")
            break
        case .poweredOn:
            print("BLE Powered On")
            startAdvertising(peripheral)
            break
        default:
            break
        }
    }
    
    func startAdvertising(_ peripheral: CBPeripheralManager?) {
        guard let peripheral = peripheral else { return }
        guard let id = App.shared.patient?.id else { return }
        let data: [String: Any] = [CBAdvertisementDataLocalNameKey: "bed_bugs_\(id)"]
        peripheral.startAdvertising(data)
    }
}
