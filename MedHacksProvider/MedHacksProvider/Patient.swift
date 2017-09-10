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
import HBStatusBarNotification
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
    
    static func checkIn(_ id: String) {
        let ref = Database.database().reference()
        ref.child("patients/\(id)/lastProvider").setValue("1")
        ref.child("patients/\(id)/checkInTime").setValue(Date().json)
        ref.child("providers/1/lastCheckInTime").setValue(Date().json)
        ref.child("patients/\(id)/name").observeSingleEvent(of: .value, with: {
            snapshot in
            
            ref.child("providers/1/lastPatient").setValue(snapshot.value)
            HBStatusBarNotification(message: "Checked In With \(String(describing: snapshot.value))", backgroundColor: UIColor.blue).show()
        })
        
    }
    
    static func checkOut(_ id: String) {
        let ref = Database.database().reference()
        ref.child("patients/\(id)/checkOutTime").setValue(Date().json)
        ref.child("providers/1/lastCheckOutTime").setValue(Date().json)
        HBStatusBarNotification(message: "Checked Out", backgroundColor: UIColor.red).show()
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
}
