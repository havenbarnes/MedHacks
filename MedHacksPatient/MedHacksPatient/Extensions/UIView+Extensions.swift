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
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.backgroundColor = self.backgroundColor?.darker(by: 60)
        }, completion: nil)
    }

}
