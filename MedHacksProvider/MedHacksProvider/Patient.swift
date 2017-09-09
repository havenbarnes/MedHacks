//
//  Patient.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PatientStatus: String {
    case turning = "Turning"
    case back = "Back"
    case left = "Left"
    case right = "Right"
    
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
}

class Patient {
    var name: String
    var room: String
    var notes: String
    var status: PatientStatus
    var lastRolled: Date
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        room = json["room"].stringValue
        notes = json["notes"].stringValue
        status = PatientStatus.from(string: json["status"].stringValue)
        lastRolled = json["lastRolled"].dateValue
    }
    
    var statusColor: UIColor? {
        let startColor = UIColor.green
        let endColor = UIColor.red
        let timeElapsed = Date().timeIntervalSince(lastRolled)
        let percentage = CGFloat(timeElapsed / 7200)
        if percentage > 1 { return UIColor.purple }
        return startColor.interpolateColorTo(end: endColor, fraction: percentage)
    }
}
