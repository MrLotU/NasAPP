//
//  EarthImageDataSource.swift
//  NasAPP
//
//  Created by Jari Koopman on 28/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation
import NasAPI

class EarthImageDataSource: NSObject {
    private var image: UIImage = UIImage(named: "Home")! // Default value with image of my home town
    let location: CLLocation
    let imageView: UIImageView
    
    init(location: CLLocation, imageView: UIImageView) {
        self.location = location
        self.imageView = imageView
    }
}

// MARK: - Networking

extension EarthImageDataSource {
    func getImage(forLocation loc: CLLocation) {
        NasAPI.getImage(forLocation: loc) { (image, error) in
            if let error = error {
                //TODO: Handle
                print("ERROR: \(error)")
            }
            guard let image = image else { return }
            image.getImage(completion: { (image, error) in
                if let error = error {
                    //TODO: Handle
                    print("Image ERROR: \(error)")
                }
                guard let image = image else { return }
                self.imageView.image = image
            })
        }
    }
}

