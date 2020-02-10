//
//  PostingView.swift
//  On The Map
//
//  Created by Abdulla Aseed on 08/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit
import MapKit

class PostingView: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLocation: UITextField!
    
    @IBOutlet weak var textFieldLink: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    var studentArry : [StudentLocation]!
    var mediaUrl: String = " "
    var updatePin : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldLocation.delegate = self
        textFieldLink.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideKeyboardWhenTappedAround()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let location = textFieldLocation.text else {return}
        if location == "" {
            let alertVC = UIAlertController(title: "Wrong Location Name", message: "Enter Location Name To Find Place On Map", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        } else {
            guard let linkText = textFieldLink.text else {return}
            guard linkText != "" else {
                let alertVC = UIAlertController(title: "Empty Media Field", message: "You Must Provide A Url.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertVC, animated: true, completion: nil)
                return
            }
            mediaUrl = linkText.prefix(6).lowercased().contains("http://") || linkText.prefix(7).lowercased().contains("http://") || linkText.prefix(8).lowercased().contains("http://") ? linkText : "https://" + linkText
            
        }
        findLocation(location)
    }
    func findLocation(_ location: String){
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            guard error == nil else {
                let alertVC = UIAlertController(title: "Failed", message: "Can not find spot: \(location)", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            let coordinate = placemark?.first!.location!.coordinate
            self.performSegue(withIdentifier: "Finish", sender: (location, coordinate))
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Finish" {
            let controller = segue.destination as! MapPinLocationView
            let locationDetails = sender as!  (String, CLLocationCoordinate2D)
            controller.location = locationDetails.0
            controller.coordinate = locationDetails.1
            controller.updatePin = updatePin
            controller.studentLocationArray = studentArry
            controller.url = mediaUrl
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func resignFirstResponder() -> Bool {
        return true
    }
}
