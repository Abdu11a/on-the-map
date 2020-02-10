//
//  ListViewController.swift
//  On The Map
//
//  Created by Abdulla Aseed on 08/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import UIKit
class ListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
   
    
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
     private var refreshControl = UIRefreshControl()
    var studentLocationArry = [StudentLocation]()
    
    var numberOfRecord : Int = 0
     override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshStudentList), for: .valueChanged)
        self.refreshStudentList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //data
         numberOfRecord.self = StudentsLocationData.studentsData.count
        self.refreshStudentList()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocationArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LocationCell")
        cell.textLabel?.text = "\(studentLocationArry[indexPath.row].firstName) " +  studentLocationArry[indexPath.row].lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text =  studentLocationArry[indexPath.row].mediaURL
        cell.detailTextLabel?.textColor = UIColor.blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var subtitle = "\(studentLocationArry[indexPath.row].mediaURL)"
        if subtitle.isValidURL {
            if subtitle.starts(with: "www"){
                subtitle = "https://" + subtitle
            }
            
            let url = URL(string: subtitle)
            openWithSafari("\(url!)")
        }
         openWithSafari("\(studentLocationArry[indexPath.row].mediaURL)")
        

    }
    
 
    @objc func refreshStudentList() {
        Client.getStudentLocation(oneStudent: false, completion:{ (data, error) in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            //data
            StudentsLocationData.studentsData = data
            self.studentLocationArry.removeAll()
            self.studentLocationArry.append(contentsOf: StudentsLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
        })
    }
    
    
    
    func getData() {
        Client.getStudentLocation(oneStudent: false, completion:{ (data, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                 StudentsLocationData.studentsData = data
                self.studentLocationArry.removeAll()
                self.studentLocationArry.append(contentsOf: StudentsLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
                self.tableView.reloadData()
                
            }
        })
    }
    
    
    
    
    @IBAction func addSpotPressed(_ sender: Any) {
        
        activityIndicator.startAnimating()
        ///
        let alertVC = UIAlertController(title: "Warning!", message: "You've Already Put Your Pin On The Map.\nWould You Like To Overwrite It?", preferredStyle: .alert)
        if studentLocationArry.count >= 0 {
            alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (_) in
                self.performSegue(withIdentifier: "addLocation",  sender: (true, self.studentLocationArry))
            }))
            alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alertVC , animated : true , completion: nil)
        }else {
            self .performSegue(withIdentifier: "addLocation", sender: (false, []))
        }
        self.activityIndicator.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let controller = segue.destination as! PostingView
            let updateFlag = sender as? (Bool, [StudentLocation])
            controller.updatePin = updateFlag?.0
            controller.studentArry = updateFlag?.1
        }
    }
    
    
    }
    

