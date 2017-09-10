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
    
    let viewModel = PatientTableModel()
    var bluetoothManager: BluetoothManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bluetoothManager = BluetoothManager.shared
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        
        viewModel.load()
        viewModel.patients.bind(to: tableView) { patients, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sbPatientCell", for: indexPath) as! PatientTableViewCell
            let patient = self.viewModel.patients[indexPath.row]
            patient.image = indexPath.row > 6 ? nil : patientImages[indexPath.row]
            cell.patient = patients[indexPath.row]
            return cell
        }
        
        _ = tableView.selectedRow.observeNext { row in
            self.tableView.deselectRow(at: IndexPath(row: row, section: 0),
                                       animated: true)
            
            let patientViewController = self.instantiate("sbPatientViewController") as! PatientViewController
            patientViewController.patient = self.viewModel.patients[row]
            self.present(patientViewController, animated: true, completion: nil)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: Date()).uppercased()
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
