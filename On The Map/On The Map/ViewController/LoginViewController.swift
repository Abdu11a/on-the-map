//
//  ViewController.swift
//  On The Map
//
//  Created by Abdulla Aseed on 07/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var userPassowrd: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail.delegate = self
        userPassowrd.delegate = self
        loginButton.roundCorners()
        
self.userEmail.becomeFirstResponder()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userEmail.text = ""
        userPassowrd.text = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideKeyboardWhenTappedAround()
        activityIndicator.stopAnimating()
    }

    @IBAction func LogInPressed(_ sender: AnyObject) {
 
        
        Client.login(with: userEmail.text!, password: userPassowrd.text!, completion: handleLoginResponse(success:error:))
 
     }
    func handleLoginResponse(success: Bool, error: Error?){
        
        if success {
            performSegue(withIdentifier: "showMap", sender: nil)
             activityIndicator.startAnimating()
        }
        else {
            let alertVC = UIAlertController(title: "Login Failed", message:error?.localizedDescription ?? "Wrong In Email or Password!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            show(alertVC, sender: nil)
            activityIndicator.stopAnimating()
        }
    }
    
    
    @IBAction func SignUpPressed(_ sender: AnyObject) {
        openWithSafari("https://auth.udacity.com/sign-up")

    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
   private func enableControllers(_ enable : Bool){
        self.enableUI(views: userEmail, userPassowrd,loginButton,signUpButton , enable: enable)
    }
    
    
}

