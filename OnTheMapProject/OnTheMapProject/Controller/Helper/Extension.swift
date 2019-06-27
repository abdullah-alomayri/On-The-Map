//
//  Extension.swift
//  OnTheMapProject
//
//  Created by xXxXx on 25/06/2019.
//  Copyright © 2019 abdullah. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertVC(title:String , msg:String)  {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true,completion: nil)
        }
    }
}
