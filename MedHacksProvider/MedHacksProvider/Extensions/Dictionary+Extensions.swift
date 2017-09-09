//
//  Dictionary+Extensions.swift
//  Funnel
//
//  Created by Jonathan Hart on 4/15/17.
//  Copyright © 2017 Funnel. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func unionInPlace(
        dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    mutating func unionInPlace<S: Sequence>(sequence: S) where
        S.Iterator.Element == (Key,Value) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
}
