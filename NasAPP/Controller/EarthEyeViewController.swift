//
//  EarthEyeViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 11/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation

typealias getLocationCompletion = (CLLocation?) -> Void

class EarthEyeViewController: NasAPPViewController, EarthImageDelegate {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var earthImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    lazy var earthImageDataSource: EarthImageDataSource = {
        return EarthImageDataSource(activityIndicator: self.activityIndicator, imageView: self.earthImageView, label: self.descriptionLabel, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
    }
        
    @objc func goButtonPressed() {
        guard let text = locationTextField.text, text != "" else {
            let alert = UIAlertController(title: "Missing required info!", message: "Location name can't be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        earthImageDataSource.getLocation(fromString: text)
    }
}
