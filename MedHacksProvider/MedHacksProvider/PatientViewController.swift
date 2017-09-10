//
//  PatientViewController.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import Bond
import SwiftyJSON
import FirebaseDatabase
import FSLineChart

class PatientViewController: UIViewController {

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!
    @IBOutlet weak var lastRolledLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var patientImageView: UIImageView!
    
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    
    var chart: FSLineChart?
    @IBOutlet weak var chartContainer: UIView!
    
    @IBOutlet weak var chartHeight: NSLayoutConstraint!
    
    var patient: Patient!
    
    var graphTimer: Timer!
    var movementValues: [Int] = []
    var movementTimes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView.alwaysBounceVertical = true
        patientImageView.image = patient.image
        
        let ref = Database.database().reference()
        ref.child("patients/\(patient.id)").observe(.value, with: {
            snapshot in
        
            guard snapshot.value != nil else { return }
            let json = JSON(snapshot.value!)
            let updatedPatient = Patient(json)
            
            if self.patient.status.value != updatedPatient.status.value {
                self.setupChart()
                self.updateChart(newValue: updatedPatient.status.value.intValue)
            }
            
            self.patient = updatedPatient
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                
                self.setupUI()
            }, completion: nil)
            
        })
        
        setNeedsStatusBarAppearanceUpdate()
        self.movementValues = [self.patient.status.value.intValue]
        self.movementTimes = [self.patient.lastRolled.value.longString]
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        
        patient.name.bind(to: nameLabel)
        patient.room.bind(to: roomLabel)
        
        topBar.backgroundColor = patient.statusColor
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: {
            timer in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.topBar.backgroundColor = self.patient.statusColor
            })
        })
        
        orientationLabel.text = patient.status.value.rawValue
        patient.status.observeNext(with: {
            status in
            
            self.orientationLabel.text = status.rawValue
            self.topBar.backgroundColor = self.patient.statusColor
        }).dispose()
        
        lastRolledLabel.text = patient.lastRolled.value.string
        patient.lastRolled.observeNext(with: {
            date in
            
            self.lastRolledLabel.text = date.string
        }).dispose()
        
        patient.notes.bind(to: notesLabel)
        patient.deviceName.bind(to: deviceLabel)
        batteryLabel.text = "\(patient.deviceBattery.value)%"
        patient.deviceBattery.observeNext(with: {
            battery in
            
            self.batteryLabel.text = "\(battery)%"
        }).dispose()
        
        scrollView.contentSize = scrollView.subviews.first!.frame.size

    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Edit Notes", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            let ref = Database.database().reference()
            ref.child("patients/\(self.patient.id)/notes").setValue(textField.text)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write some notes."
            textField.text = self.patient.notes.value
            textField.autocapitalizationType = .sentences
            textField.font = UIFont(name: ".SFUIDisplay-Semibold", size: 20)!
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupChart() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.chart = FSLineChart(frame: self.chartContainer.bounds)
            self.chart?.gridStep = 1
            self.chart!.verticalGridStep = 1
            self.chart!.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            self.chartContainer.addSubview(self.chart!)
        })
    }
    
    func updateChart(newValue: Int) {
        chart?.removeFromSuperview()
        chart = FSLineChart(frame: self.chartContainer.bounds)
        chartContainer.addSubview(chart!)

        movementValues.append(newValue)
        movementTimes.append(Date().longString)
        
        //self.chart?.labelForIndex = { self.movementTimes[Int($0)] }
        
        self.chart?.clearData()
        self.chart?.setChartData(movementValues)
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
