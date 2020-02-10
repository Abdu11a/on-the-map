//
//  loginExtension.swift
//  On The Map
//
//  Created by Abdulla Aseed on 17/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController  {
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        Client.logout{ (success: Bool, error: Error?) in
            if success {
                self.dismiss(animated: true, completion: nil)
                
            }
            
            print(error?.localizedDescription ?? "")
        }
    }
}
