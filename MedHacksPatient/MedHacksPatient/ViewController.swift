//
//  ViewController.swift
//  MedHacksPatient
//
//  Created by Haven Barnes on 9/8/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MotionManagerDelegate {
    
    @IBOutlet weak var gX: UILabel!
    @IBOutlet weak var gY: UILabel!
    @IBOutlet weak var gZ: UILabel!
    @IBOutlet weak var aX: UILabel!
    @IBOutlet weak var aY: UILabel!
    @IBOutlet weak var aZ: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startMonitoringPressed(_ sender: Any) {
        let manager = MotionManager()
        manager.delegate = self
    }
    
    var i = 0
    func didUpdate(_ motion: Motion) {
        print(motion)
        
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

