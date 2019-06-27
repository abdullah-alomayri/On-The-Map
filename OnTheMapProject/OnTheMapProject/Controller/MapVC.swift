//
//  MapVC.swift
//  OnTheMapProject
//
//  Created by xXxXx on 22/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class MapVC: UIViewController {
    
    var studentsLocations: [StudentLocation]! {
        return Global.shared.studentsLocations
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (studentsLocations == nil) {
            
            reloadStudentsLocations(self)
        } else {
            DispatchQueue.main.async {
                ///
                self.updateAnnotations()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
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
                self.updateAnnotations()
            }
            
            
        }
    }
    
    func updateAnnotations() {
        var annotations = [MKPointAnnotation]()
        for studentLocation in studentsLocations {
            
            let lat = CLLocationDegrees(studentLocation.latitude ?? 0)
            let long = CLLocationDegrees(studentLocation.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName ?? ""
            let last = studentLocation.lastName ?? ""
            let mediaURL = studentLocation.mediaURL ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            
            
            if !mapView.annotations.contains(where: {$0.title == annotation.title}) {
                annotations.append(annotation)
            }
        }
        
        print("New annoutations = ", annotations.count)
        mapView.addAnnotations(annotations)
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        ///
        let reuseId = "pinId"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            guard let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) else { return }
            app.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
