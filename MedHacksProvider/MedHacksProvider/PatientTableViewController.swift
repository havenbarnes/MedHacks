//
//  ViewController.swift
//  MedHacksProvider
//
//  Created by Haven Barnes on 9/8/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import Firebase
import Bond

class PatientTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PatientTableModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.load()
        viewModel.patients.bind(to: tableView) { patients, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sbPatientCell", for: indexPath) as! PatientTableViewCell
            cell.patient = patients[indexPath.row]
            return cell
        }
    }
}

