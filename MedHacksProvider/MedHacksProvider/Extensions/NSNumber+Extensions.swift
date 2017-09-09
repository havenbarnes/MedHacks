//
//  NSNumber+Extensions.swift
//  Funnel
//
//  Created by Haven Barnes on 4/29/17.
//  Copyright © 2017 Funnel. All rights reserved.
//

import Foundation

extension NSNumber {
    
    func socialCountString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        if self.int64Value < 10000 {
            
            return numberFormatter.string(from: self)!
            
        } else if self.int64Value >= 10000 && self.int64Value < 100000 {
            
            let reduced = self.doubleValue / 1000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 1
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)K"
            
        } else if self.int64Value >= 100000 && self.int64Value < 1000000 {
            
            let reduced = self.doubleValue / 1000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 0
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)K"
            
        } else if self.int64Value >= 1000000 && self.int64Value < 10000000 {
            
            let reduced = self.doubleValue / 1000000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 1
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)M"
            
        } else if self.int64Value >= 10000000 && self.int64Value < 100000000 {
            
            let reduced = self.doubleValue / 1000000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 1
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)M"
            
        } else if self.int64Value >= 100000000 && self.int64Value < 1000000000 {
            
            let reduced = self.doubleValue / 1000000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 0
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)M"
            
        } else if self.int64Value >= 1000000000 && self.int64Value < 1000000000000 {
            
            let reduced = self.doubleValue / 1000000000.0
            let simpleNumber = NSNumber(value: reduced)
            
            numberFormatter.maximumFractionDigits = 0
            
            let numberString = numberFormatter.string(from: simpleNumber)!
            return "\(numberString)B"
            
        } else {
            return "😱"
        }
    }
}
