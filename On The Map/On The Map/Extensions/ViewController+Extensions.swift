//
//  ViewController+Extensions.swift
//  On The Map
//
//  Created by Abdulla Aseed on 08/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
 
   
    
    
    func performUIUpdatesOnMain(_ Updates : @escaping () -> Void){
        DispatchQueue.main.async {
            Updates()
        }
    }
    
    func enableUI(views: UIControl...,enable:Bool){
        performUIUpdatesOnMain {
            for view in views {
                view.isEnabled = enable
            }
        }
    }
    
    func openWithSafari(_ url : String ,action:(() -> Void)? = nil ) {
        guard let url = URL(string: url),UIApplication.shared.canOpenURL(url) else {
            performUIUpdatesOnMain {
             let ac = UIAlertController(title: "Message", message: "Invalid link.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                 action?()
            }))
                self.present(ac,animated: true) }
            return
        }
        UIApplication.shared.open(url,options: [:])
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let reloadStarted = Notification.Name("reloadStarted")
    static let reloadCompleted = Notification.Name("reloadCompleted")

}
