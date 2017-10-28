//
//  ViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 09/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class MainViewController: NasAPPViewController {

    //MARK: Outlets
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var roverButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var asteroidButton: UIButton!
    @IBOutlet weak var launchImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchImageView.image = UIImage(named: "LaunchScreen")
        UIView.animate(withDuration: 1) {
            self.launchImageView.alpha = 0
        }
        roverButton.imageView?.contentMode = .scaleAspectFill
        eyeButton.imageView?.contentMode = .scaleAspectFill
        asteroidButton.imageView?.contentMode = .scaleAspectFill
        
        roverButton.addTarget(self, action: #selector(roverButtonPressed), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(eyeButtonPressed), for: .touchUpInside)
        asteroidButton.addTarget(self, action: #selector(asteroidButtonPressed), for: .touchUpInside)
    }
}

//MARK: - Navigation
extension MainViewController {
    @objc func eyeButtonPressed() {
        performSegue(withIdentifier: "showEarthEye", sender: nil)
    }
    
    @objc func asteroidButtonPressed() {
        performSegue(withIdentifier: "showAsteroids", sender: nil)
    }
    
    @objc func roverButtonPressed() {
        performSegue(withIdentifier: "showRover", sender: nil)
    }
}

