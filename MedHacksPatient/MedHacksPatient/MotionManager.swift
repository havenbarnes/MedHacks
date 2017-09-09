//
//  MotionManager.swift
//  Perform
//
//  Created by Haven Barnes on 5/8/17.
//  Copyright © 2017 ___FULLUSERNAME__. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate {
    func didUpdate(_ motion: Motion)
}

struct Motion {
    var accelX: Double
    var accelY: Double
    var accelZ: Double
    var gyroX: Double
    var gyroY: Double
    var gyroZ: Double
    
    init(cmMotion: CMDeviceMotion) {
        accelX = cmMotion.userAcceleration.x
        accelY = cmMotion.userAcceleration.y
        accelZ = cmMotion.userAcceleration.z
        gyroX = cmMotion.rotationRate.x
        gyroY = cmMotion.rotationRate.y
        gyroZ = cmMotion.rotationRate.z
    }
}

class MotionManager {
    
    var delegate: MotionManagerDelegate?
    private var coreMotion = CMMotionManager()
    private var buffer = 0
    
    init() {
        coreMotion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
            cmMotion, error in
            
            guard cmMotion != nil else { return }
            
            let motion = Motion(cmMotion: cmMotion!)
            self.delegate?.didUpdate(motion)
            
        })
    }
    
    func stop() {
        coreMotion.stopDeviceMotionUpdates()
    }
}
