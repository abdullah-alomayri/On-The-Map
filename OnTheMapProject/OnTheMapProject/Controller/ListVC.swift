//
//  ListVC.swift
//  OnTheMapProject
//
//  Created by xXxXx on 22/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation

import UIKit
///
class ListVC: UITableViewController {
    
    let cellId = "cellId"
    
    var studentsLocations: [StudentLocation]! {
        return Global.shared.studentsLocations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if studentsLocations == nil {
            ///
            reloadStudentsLocations(self)
        } else {
            DispatchQueue.main.async {
                ///
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UdacityAPI.deleteSession { (error) in
            if let error = error {
                self.alertVC(title: "Error", msg: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func postPin(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            let alert = UIAlertController(title: "You have posted a location. would you like to overwrite your current location?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: { (action) in
                self.performSegue(withIdentifier: "mapToNewLocation", sender: self)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "mapToNewLocation", sender: self)
        }
    }
    
    @IBAction func reloadStudentsLocations(_ sender: Any) {
        UdacityAPI.Parse.getStudentsLocations { (_, error) in
            if let error = error {
                self.alertVC(title: "Error", msg: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentsLocations[indexPath.row]
        guard let toOpen = studentLocation.mediaURL , let url = URL(string: toOpen) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
