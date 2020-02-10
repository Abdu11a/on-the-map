//
//  MapViewController.swift
//  On The Map
//
//  Created by Abdulla Aseed on 08/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController  {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          refreshTheMap(animated)
    }

    @IBAction func refreshTheMap(_ sender: Any) {
        getData()
    }
    
    @IBAction func addSpotPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        ///
        let alertVC = UIAlertController(title: "Warning!", message: "You've already put your pin on the map.\nWould you like to overwrite it?", preferredStyle: .alert)
        Client.getStudentLocation(oneStudent: false) { (data, error) in
            guard let data = data else {
                let alert = UIAlertController(title: "Warning!", message: error?.localizedDescription ?? "" , preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if data.count > 0 {
                alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (_) in
                     self.performSegue(withIdentifier: "addLocation",  sender: (true, data))
                }))
                alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alertVC , animated : true , completion: nil)
            }else {
                self .performSegue(withIdentifier: "addLocation", sender: (false, []))
            }
        }
         self.activityIndicator.stopAnimating()
    }
    
    func getData(){
        activityIndicator.startAnimating()
        Client.getStudentLocation(oneStudent: false , completion: { (data, error) in
            guard let data = data else {
                 return
            }
            
                StudentsLocationData.studentsData = data
               self.copyData()
           
            self.activityIndicator.stopAnimating()
        })
    }
    func copyData(){
        self.annotations.removeAll()
        self.mapView.removeAnnotations(self.mapView.annotations)
        //data
        for n in StudentsLocationData.studentsData {
            self.annotations.append(n.getMapAnnotation())
        }
        self.mapView.addAnnotations(self.annotations)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addLocation" {
            let destinationVC = segue.destination as? PostingView
            let updateStudentInfo = sender as? (Bool, [StudentLocation])
            destinationVC?.updatePin = updateStudentInfo?.0
            destinationVC?.studentArry = updateStudentInfo?.1
        }
    }
}
