//
//  Patient.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import SwiftyJSON

class Patient {
    var name: String
    var room: String
    var notes: String
    var lastRolled: Date
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        room = json["room"].stringValue
        notes = json["notes"].stringValue
        lastRolled = json["lastRolled"].dateValue
    }
}
