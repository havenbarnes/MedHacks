//
//  PatientTableViewCell.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import Bond
class PatientTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    
    var patient: Patient! {
        didSet {
            patient.name.bind(to: nameLabel)
            patient.room.bind(to: roomLabel)
            
            statusView.backgroundColor = patient.statusColor
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: {
                timer in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.statusView.backgroundColor = self.patient.statusColor
                })
            })
            
            if patient.needsAttention {
                statusView.flash()
            } else {
                statusView.layer.removeAllAnimations()
            }
            
            if patient.status.value != .turning {
                statusLabel.text = patient.status.value.rawValue
            }
            patientImage.image = patient.image
        }
    }
}
