//
//  UIViewController+Extensions.swift
//
//  Created by Haven Barnes on 4/6/17.
//

import UIKit
import SafariServices

extension UIViewController {
    func instantiate(_ identifier: String, storyboard: String = "Main") -> UIViewController {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
    func present(_ identifier: String, storyboard: String = "Main") {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func show(_ identifier: String, storyboard: String = "Main") {
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        self.show(viewController, sender: self)
    }
    
    /**
     Displays an "Ok" alert controller in given view controller
     
     - parameter title: Title of the alert controller
     - parameter message: Message of the alert controller
     - parameter viewController: View controller in which you want the alert controller presented
     */
    func showOKAlert(title: String, message: String?) {
        showOKAlert(title: title, message: message, handler: nil)
    }
    
    func showOKAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title:title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentUrl(_ url: URL) {
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    
    func showUrl(_ url: URL) {
        let svc = SFSafariViewController(url: url)
        show(svc, sender: nil)
    }
}
