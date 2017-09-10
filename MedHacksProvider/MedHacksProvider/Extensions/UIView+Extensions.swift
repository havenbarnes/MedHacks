//
//  UIView+Extensions.swift
//  Funnel
//
//  Created by Haven Barnes on 4/20/17.
//  Copyright © 2017 Funnel. All rights reserved.
//

import UIKit

extension UIView {
    func circleize() {
        layer.cornerRadius = frame.width / 2
        print(frame.width)
    }
    
    func flash() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.alpha = 1
        }, completion: nil)
    }
}
