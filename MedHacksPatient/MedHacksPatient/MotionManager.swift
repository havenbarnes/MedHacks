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
    func didUpdate(motion: Motion)
    func didUpdate(orientation: PatientStatus)
}

class Motion {
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
    
    func start() {
        coreMotion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
            cmMotion, error in
            
            if let attitude = cmMotion?.attitude {
                
                let angle = attitude.roll * 180.0/Double.pi

                if angle > 70 && angle < 110 {
                    self.delegate?.didUpdate(orientation: .left)
                } else if angle < -70 && angle > -110 {
                    self.delegate?.didUpdate(orientation: .right)
                } else if angle > -20 && angle < 20 {
                    self.delegate?.didUpdate(orientation: .back)
                } else {
                    self.delegate?.didUpdate(orientation: .turning)
                }
            }
            
            guard cmMotion != nil else { return }
            
            let motion = Motion(cmMotion: cmMotion!)
            self.delegate?.didUpdate(motion: motion)
            
        })
    }
    
    func stop() {
        coreMotion.stopDeviceMotionUpdates()
    }
}
