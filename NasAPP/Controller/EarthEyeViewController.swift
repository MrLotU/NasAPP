//
//  EarthEyeViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 11/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class EarthEyeViewController: NasAPPViewController {

    @IBOutlet weak var homeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
}
