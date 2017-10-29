//
//  NasAPPViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 16/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    func showAlert(withTitle title: String, andMessage message: String)
}

class NasAPPViewController: UIViewController, AlertDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: view.bounds.width/2, y: 0)
        gradient.endPoint = CGPoint(x: view.bounds.width/2, y: 1)
        gradient.colors = [UIColor(red: 33/255, green: 29/255, blue: 59/255, alpha: 1).cgColor, UIColor(red: 27/255, green: 23/255, blue: 52/255, alpha: 1).cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @objc func didPressHomeButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
