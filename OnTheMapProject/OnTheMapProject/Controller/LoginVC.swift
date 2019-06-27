//
//  LoginVC.swift
//  OnTheMapProject
//
//  Created by xXxXx on 22/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func login(_ loggingIn: UIButton) {
        setLoggingIn(true)
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces),
            let password = passwordField.text?.trimmingCharacters(in: .whitespaces),
            !email.isEmpty, !password.isEmpty
            else {
                
                setLoggingIn(false)
                return
        }
        
        UdacityAPI.postSession(with: email, password: password) { (result, error) in
            if let error = error {
                self.alertVC(title: "Error", msg: error.localizedDescription)
                self.setLoggingIn(false)
                return
            }
            if let error = result?["error"] as? String {
                self.alertVC(title: "Error", msg: error)
                self.setLoggingIn(false)
                return
            }
            if let session = result?["session"] as? [String:Any], let sessionId = session["id"] as? String {
                print(sessionId)
                UdacityAPI.deleteSession { (error) in
                    if let error = error {
                        self.alertVC(title: "Error", msg: error.localizedDescription)
                        self.setLoggingIn(false)
                        return
                    }
                    self.setLoggingIn(false)
                    DispatchQueue.main.async {
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.performSegue(withIdentifier: "showTapVC", sender: self)
                    }
                }
                
            }
            self.setLoggingIn(false)
        }
        
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            self.emailField.isEnabled = !loggingIn
            self.passwordField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = NSURL(string: "https://www.udacity.com/") {
            
            UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
            
        }
    }
}
