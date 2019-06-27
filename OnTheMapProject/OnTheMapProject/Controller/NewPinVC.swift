//
//  NewPinVC.swift
//  OnTheMapProject
//
//  Created by xXxXx on 22/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation

class NewPinVC: UIViewController {
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNewPinVCToShareVC" {
            let vc = segue.destination as! ShareVC
            vc.locationCoordinate = locationCoordinate
            vc.locationName = locationName
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findButton(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        updateUI(processing: true)
        guard let locationName = locationField.text?.trimmingCharacters(in: .whitespaces), !locationName.isEmpty
            else {
                alertVC(title: "Warning", msg: "Location should be filled! ")
                updateUI(processing: false)
                return
        }
        getCoordinateForm(location: locationName) { (locationCoordinate, error) in
            if let error = error {
                self.alertVC(title: "Error", msg: "Try different city name")
                print(error.localizedDescription)
                self.updateUI(processing: false)
                return
            }
            self.locationCoordinate = locationCoordinate
            self.locationName = locationName
            self.updateUI(processing: false)
            self.performSegue(withIdentifier: "fromNewPinVCToShareVC", sender: self)
        }
    }
    func updateUI(processing: Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !processing
            self.findButton.isEnabled = !processing
        }
        
    }
    func getCoordinateForm(location: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(location) {placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
