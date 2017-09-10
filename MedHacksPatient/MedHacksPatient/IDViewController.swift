//
//  ViewController.swift
//  MedHacksPatient
//
//  Created by Haven Barnes on 9/8/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import Firebase
import HBStatusBarNotification
import Bond
import SwiftyJSON

class IDViewController: UIViewController, MotionManagerDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var switchPatientButton: UIButton!
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var layingOnLabel: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!

    let manager = MotionManager()
    var patient: Patient!
    var running = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        patient = App.shared.patient
        patientImageView.image = patient.image
        backgroundColorView.backgroundColor = patient.statusColor
        recordButton.setTitleColor(patient.statusColor, for: .normal)
        switchPatientButton.setTitleColor(patient.statusColor, for: .normal)
        

        manager.delegate = self
        
        let ref = Database.database().reference()
        ref.child("patients/\(patient.id)").observe(.value, with: {
            snapshot in
            
            guard snapshot.value != nil else { return }
            let json = JSON(snapshot.value!)
            let updatedPatient = Patient(json)
        
            self.patient = updatedPatient
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                
                self.setupUI()
            }, completion: nil)
            
        })
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
            timer in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundColorView.backgroundColor = self.patient.statusColor
                self.recordButton.setTitleColor(self.patient.statusColor, for: .normal)
                self.switchPatientButton.setTitleColor(self.patient.statusColor, for: .normal)
            })
            
            if self.patient.needsAttention {
                self.backgroundColorView.flash()
            }
        })
        
        setupUI()
    }
    
    func setupUI() {
        patient.name.bind(to: patientNameLabel)
        patient.notes.bind(to: notesLabel)
    }

    @IBAction func startMonitoringPressed(_ sender: Any) {
        let button = sender as! UIButton
        if !running {
            layingOnLabel.isHidden = false
            layingOnLabel.text = "Laying On"
            button.setTitle("Stop", for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            manager.start()
        } else {
            layingOnLabel.isHidden = false
            layingOnLabel.text = "Press Start"
            orientationLabel.text = "To Resume"
            button.setTitle("Start", for: .normal)
            button.setTitleColor(UIColor.green, for: .normal)
            manager.stop()
        }
        running = !running
    }
    
    func didLogin() {
        HBStatusBarNotification(message: "Login Successful!", backgroundColor: UIColor.blue).show()
    }
    
    func didUpdate(orientation: PatientStatus) {
        if orientation == .turning {
            layingOnLabel.isHidden = true
            orientationLabel.text = "Turning"
            return
        }
        
        orientationLabel.text = orientation.rawValue
        layingOnLabel.isHidden = false
        
        // Check if diff value and update firebase
        if orientation != patient.status.value {
            App.shared.patient?.status = Observable(orientation)
            App.shared.patient?.update()
        }
    }
    
    @IBAction func switchPatientButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func didUpdate(motion: Motion) {}
}

