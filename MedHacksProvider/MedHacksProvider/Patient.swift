//
//  Patient.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Patient {
    var name: String
    var room: String
    var notes: String
    var activity: Activity
    var lastRolled: Date
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        room = json["room"].stringValue
        notes = json["notes"].stringValue
        activity = Activity(json["activity"])
        let lastRolledString = json["lastRolled"].stringValue
        lastRolled = lastRolledString.dateValue
    }
}

extension String {
    var dateValue: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.date(from: self) ?? Date()
    }
}
