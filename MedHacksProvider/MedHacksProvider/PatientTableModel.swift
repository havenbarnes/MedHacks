//
//  PatientTableModel.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/9/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Firebase
import FirebaseDatabase
import SwiftyJSON
import Bond

class PatientTableModel {
    
    var ref: DatabaseReference!
    
    let patients = MutableObservableArray<Patient>()
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
    }
    
    func load() {
        self.ref.child("patients").observe(.value, with: {
            snapshot in
            
            var firebasePatients:[Patient] = []
            for patientJson in snapshot.children.allObjects as! [DataSnapshot] {
                firebasePatients.append(Patient(JSON(patientJson.value!)))
            }
            self.patients.replace(with: firebasePatients)
        })
        
    }
}
