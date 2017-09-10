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
    @IBOutlet weak var patientImageView: UIImageView!
    
    var patient: Patient! {
        didSet {
            patientImageView.image = patient.image
            patient.name.bind(to: nameLabel)
            patient.room.bind(to: roomLabel)
        }
    }
}
