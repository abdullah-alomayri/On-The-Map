//
//  ShareVC.swift
//  OnTheMapProject
//
//  Created by xXxXx on 22/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import CoreLocation


class ShareVC: UIViewController {
    
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    @IBOutlet weak var linkField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate!
        mapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    
    @IBAction func submit(_ sender: Any) {
        
        UdacityAPI.Parse.postStudentLocation(link: linkField.text ?? "", locationCoordinate: locationCoordinate, locationName: locationName) { (error) in
            if let error = error {
                self.alertVC(title: "Error", msg: error.localizedDescription)
                return
            }
            ///
            UserDefaults.standard.set(self.locationName, forKey: "studentLocation")
            DispatchQueue.main.async {
                ////
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
extension ShareVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pinId"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
