//
//  ViewController.swift
//  MedHacksPatient
//
//  Created by Haven Barnes on 9/8/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MotionManagerDelegate {
    
    @IBOutlet weak var orientationLabel: UILabel!
    
    @IBOutlet weak var gX: UILabel!
    @IBOutlet weak var gY: UILabel!
    @IBOutlet weak var gZ: UILabel!
    @IBOutlet weak var aX: UILabel!
    @IBOutlet weak var aY: UILabel!
    @IBOutlet weak var aZ: UILabel!
    
    let manager = MotionManager()
    var running = false

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
    }

    @IBAction func startMonitoringPressed(_ sender: Any) {
        let button = sender as! UIButton
        if !running {
            button.setTitle("Stop Monitoring", for: .normal)
            button.backgroundColor = UIColor.red
            manager.start()
        } else {
            button.setTitle("Start Monitoring", for: .normal)
            button.backgroundColor = UIColor.green
            manager.stop()
        }
        running = !running
    }
    
    var dataString = ""
    var i = 0
    
    func didUpdate(orientation: Orientation) {
        if orientation == .turning {
            orientationLabel.text = "Turning"    
            return
        }
        orientationLabel.text = "Laying On: \(orientation.rawValue)"
    }
    
    func didUpdate(motion: Motion) {
        
        //dataString += "\(motion.gyroX),\(motion.gyroX),\(motion.gyroX),"
        //    + "\(motion.accelX),\(motion.accelY),\(motion.accelZ)\n"
        
        i += 1
        
        if i == 30 {
            i = 0
            gX.text = "Gyro X  \(motion.gyroX * 100)"
            gY.text = "Gyro Y  \(motion.gyroY * 100)"
            gZ.text = "Gyro Z  \(motion.gyroZ * 100)"
            aX.text = "Accel X \(motion.accelX * 100)"
            aY.text = "Accel Y \(motion.accelY * 100)"
            aZ.text = "Accel Z \(motion.accelZ * 100)"
        }
        
    }
}

