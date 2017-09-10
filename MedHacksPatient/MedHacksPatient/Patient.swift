//
//  Patient.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bond
import Firebase

enum PatientStatus: String {
    case turning = "Turning"
    case back = "Back"
    case left = "Left Side"
    case right = "Right Side"
    
    static func from(string: String) -> PatientStatus {
        var status: PatientStatus
        switch string {
        case "turning":
            status = .turning
            break
        case "back":
            status = .back
            break
        case "left":
            status = .left
            break
        case "right":
            status = .right
            break
        default:
            status = .turning
            break
        }
        return status
    }
    
    var jsonValue: String {
        switch self {
        case .left:
            return "left"
        case .back:
            return "back"
        case .right:
            return "right"
        default:
            return "back"
        }
    }
    
    var intValue: Int {
        switch self {
        case .left:
            return 1
        case .back:
            return 0
        case .right:
            return -1
        default:
            return 0
        }
    }
}

class Patient {
    
    var id: String
    var image: UIImage?
    var name: Observable<String>
    var interval: Observable<Int>
    var room: Observable<String>
    var notes: Observable<String>
    var status: Observable<PatientStatus>
    var lastRolled: Observable<Date>
    var deviceName: Observable<String>
    var deviceBattery: Observable<Int>
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        name = Observable(json["name"].stringValue)
        interval = Observable(json["interval"].intValue)
        room = Observable(json["room"].stringValue)
        notes = Observable(json["notes"].stringValue)
        status = Observable(PatientStatus.from(string: json["status"].stringValue))
        lastRolled = Observable(json["lastRolled"].dateValue)
        deviceName = Observable(json["client"]["name"].stringValue)
        deviceBattery = Observable(json["client"]["battery"].intValue)
    }
    
    var needsAttention: Bool {
        let timeElapsed = Date().timeIntervalSince(lastRolled.value)
        let percentage = CGFloat(timeElapsed / Double(interval.value))
        return percentage > 1.0
    }
    
    var statusColor: UIColor? {
        let timeElapsed = Date().timeIntervalSince(lastRolled.value)
        let percentage = CGFloat(timeElapsed / Double(interval.value))
        
        var startColor: UIColor!
        var endColor: UIColor!
        if percentage < 0.5 {
            startColor = UIColor.green
            endColor = UIColor.yellow
        } else {
            startColor = UIColor.yellow
            endColor = UIColor.red
        }
        
        return startColor.interpolateColorTo(end: endColor, fraction: percentage)
    }
    
    static func create(name: String, room: String) {
        let id = UUID().uuidString
        UIDevice.current.isBatteryMonitoringEnabled = true
        let patientJson: [String: Any] = [
            "id": id,
            "name": name,
            "room": room,
            "interval": 360,
            "notes": "",
            "status": PatientStatus.back.jsonValue,
            "lastRolled": Date().json,
            "client": [
                "name": "iPhone",
                "battery": UIDevice.current.batteryLevel * 100
            ]
        ]
        let ref = Database.database().reference()
        ref.child("patients/\(id)").setValue(patientJson)
    }
    
    func update() {
        UIDevice.current.isBatteryMonitoringEnabled = true

        let ref = Database.database().reference()
        ref.child("patients/\(self.id)/status").setValue(status.value.jsonValue)
        ref.child("patients/\(self.id)/lastRolled").setValue(Date().json)
        ref.child("patients/\(self.id)/client/name").setValue("iPhone")
        ref.child("patients/\(self.id)/client/battery").setValue(UIDevice.current.batteryLevel * 100)
    }
}
