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
    var id: Int
    var name: Observable<String>
    var room: Observable<String>
    var notes: Observable<String>
    var status: Observable<PatientStatus>
    var lastRolled: Observable<Date>
    var deviceName: Observable<String>
    var deviceBattery: Observable<Int>
    
    init(_ json: JSON) {
        id = json["id"].intValue
        name = Observable(json["name"].stringValue)
        room = Observable(json["room"].stringValue)
        notes = Observable(json["notes"].stringValue)
        status = Observable(PatientStatus.from(string: json["status"].stringValue))
        lastRolled = Observable(json["lastRolled"].dateValue)
        deviceName = Observable(json["client"]["name"].stringValue)
        deviceBattery = Observable(json["client"]["battery"].intValue)
    }
    
    var statusColor: UIColor? {
        let startColor = UIColor.green
        let endColor = UIColor.red
        let timeElapsed = Date().timeIntervalSince(lastRolled.value)
        let percentage = CGFloat(timeElapsed / 7200)
        if percentage > 1 { return UIColor.purple }
        return startColor.interpolateColorTo(end: endColor, fraction: percentage)
    }
}
