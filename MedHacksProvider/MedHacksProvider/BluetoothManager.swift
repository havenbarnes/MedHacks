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
class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let shared = BluetoothManager()
    
    var centralManager: CBCentralManager?
    
    override init() {
        super.init()
        
        let options = [CBCentralManagerOptionShowPowerAlertKey: false]
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: options)
        centralManager?.delegate = self
    }
    
    func stop() {
        centralManager?.stopScan()
    }
    
    // MARK: - Core Bluetooth Delegate Functions
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            print("BLE Powered Off")
            break
        case .poweredOn:
            print("BLE Powered On")
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true)])
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
                
                // This is our guy!
                let id = profileIdData.replacingOccurrences(of: "bed_bugs_", with: "")
                patientId = id
                analyzeRSSI(RSSI.intValue)
            }
        }
    }
    
    var timer: Timer?
    var patientId: String!
    var accumulator = 0
    
    var checkedIn = false
    
    func analyzeRSSI(_ rssi: Int) {
        if !checkedIn {
            if rssi > -38 {
                accumulator += 1
                timer?.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {
                    timer in
                    
                    self.accumulator = 0
                })
            }
            
            if accumulator == 10 {
                accumulator = 0
                print("CHECK IN")
                checkedIn = true
                Patient.checkIn(patientId)
            }
        } else {
            if rssi < -70 {
                accumulator += 1
                timer?.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {
                    timer in
                    
                    self.accumulator = 0
                })
            }
            
            if accumulator == 10 {
                accumulator = 0
                print("CHECK OUT")
                checkedIn = false
                Patient.checkOut(patientId)
            }

        }
    }
    
}
