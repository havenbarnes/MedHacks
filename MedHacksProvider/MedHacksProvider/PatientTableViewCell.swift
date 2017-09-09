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
            self.nameLabel.text = patient.name
            self.roomLabel.text = patient.room
            self.statusView.backgroundColor = patient.statusColor
        }
    }
}
