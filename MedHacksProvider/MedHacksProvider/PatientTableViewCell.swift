//
//  PatientTableViewCell.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var patient: Patient! {
        didSet {
            nameLabel.text = patient.name
            roomLabel.text = patient.room
            statusView.backgroundColor = patient.statusColor
            if patient.status != .turning {
                statusLabel.text = patient.status.rawValue
            }
        }
    }
}
