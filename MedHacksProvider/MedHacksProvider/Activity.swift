//
//  Activity.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import SwiftyJSON

struct Activity {
    var values: [ActivityValue]
    
    init(_ json: JSON) {
        for
    }
}

struct ActivityValue {
    var time: Date
    var activity: Double
}
