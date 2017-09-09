//
//  PatientTableModel.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import FirebaseDatabase

class PatientTableModel {
    
    var ref: DatabaseReference!
    
    var patients: [Patient] = []
    
    init() {
        ref = Database.database().reference()
    }
    
    func load() {
        let patientsJson = self.ref.child("patients")
    }
}
