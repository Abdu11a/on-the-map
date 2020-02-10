//
//  MapPinLocationView.swift
//  On The Map
//
//  Created by Abdulla Aseed on 08/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapPinLocationView: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: String!
    var updatePin: Bool!
    
    var url: String!
    
    var coordinate: CLLocationCoordinate2D!

    var studentLocationArray: [StudentLocation]!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard coordinate != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        addPin(coordinate: coordinate)
    }
    
    @IBAction func finish(_ sender: Any) {
        Client.getUserData { (userData, error) in
            guard let userData = userData else {
                return }
            
            let studentLocationRequest = PostLocation(uniqueKey: userData.key, firstName: "Abdullah", lastName: "Alsahli", mapString: self.location, mediaURL: self.url, latitude: Float(self.coordinate.latitude) , longitude:Float(self.coordinate.longitude) )
            self.updatePin ? self.updateExistedPin(postLocationData: studentLocationRequest) : self .postPin(postLocationData: studentLocationRequest)
        }
    }
    
    func postPin(postLocationData: PostLocation){
        Client.postStudentLocation(postLocation: postLocationData) { (success, error) in
            if error != nil {
                let alertVC = UIAlertController(title: "Can't Post New Pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post new pin")", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func updateExistedPin(postLocationData: PostLocation){
        if studentLocationArray.isEmpty {
            return }
        Client.putStudentLocation(objectID: studentLocationArray[0].objectID, postLocation: postLocationData) { (success, error) in
            if error != nil {
                let alertVC = UIAlertController(title: "Can't Post New Pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post new pin")", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
     }
    
    func addPin(coordinate : CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.title = location
        annotation.coordinate = coordinate
        let longitudeDelta = 0.01
        let latitudeDelta = 0.01
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: latitudeDelta , longitudeDelta: longitudeDelta))
        
      
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
            mapView.regionThatFits(region)
            
        
    }
   
}
