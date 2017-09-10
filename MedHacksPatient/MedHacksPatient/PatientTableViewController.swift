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
import ReactiveKit

let patientImages = [#imageLiteral(resourceName: "person1"), #imageLiteral(resourceName: "person7"), #imageLiteral(resourceName: "person2"), #imageLiteral(resourceName: "person3"), #imageLiteral(resourceName: "person4"), #imageLiteral(resourceName: "person5"), #imageLiteral(resourceName: "person6")]

class PatientTableViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PatientTableModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        
        viewModel = PatientTableModel()
        viewModel.load()
        viewModel.patients.bind(to: tableView) { patients, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sbPatientCell", for: indexPath) as! PatientTableViewCell
            let patient = patients[indexPath.row]
            patient.image = patientImages[indexPath.row]
            cell.patient = patient
            return cell
        }
        
        _ = tableView.selectedRow.observeNext { row in
            self.tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            App.shared.patient = self.viewModel.patients[row]
            self.present("sbViewController")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: Date()).uppercased()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "New Patient", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            
            let nameField = alertController.textFields![0] as UITextField
            let roomField = alertController.textFields![1] as UITextField
            Patient.create(name: nameField.text!, room: roomField.text!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Patient Name"
            textField.autocapitalizationType = .words
            textField.font = UIFont(name: ".SFUIDisplay-Semibold", size: 20)!
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Room Number"
            textField.autocapitalizationType = .words
            textField.font = UIFont(name: ".SFUIDisplay-Semibold", size: 20)!
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ReactiveExtensions where Base: UITableView {
    public var delegate: ProtocolProxy {
        return base.protocolProxy(for: UITableViewDelegate.self, setter: NSSelectorFromString("setDelegate:"))
    }
}

extension UITableView {
    var selectedRow: Signal<Int, NoError> {
        return reactive.delegate.signal(for: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) { (subject: PublishSubject<Int, NoError>, _: UITableView, indexPath: NSIndexPath) in
            subject.next(indexPath.row)
        }
    }
}
