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

protocol EarthImageDelegate: AlertDelegate {}

class EarthImageDataSource: NSObject {
    private var image: UIImage = UIImage(named: "Home")! // Default value with image of my home town
    let activityIndicator: UIActivityIndicatorView
    let imageView: UIImageView
    let label: UILabel
    let delegate: EarthImageDelegate
    var locationName: String = ""
    
    init(activityIndicator: UIActivityIndicatorView, imageView: UIImageView, label: UILabel, delegate: EarthImageDelegate) {
        self.activityIndicator = activityIndicator
        self.imageView = imageView
        self.label = label
        self.delegate = delegate
    }
    
    func getLocation(fromString string: String) {
        self.locationName = string
        getLocation(fromString: string) { (location) in
            if let location = location {
                self.getImage(forLocation: location)
            }
        }
    }
}

// MARK: - GeoCoding

extension EarthImageDataSource {
    private func getLocation(fromString locationString: String, completion: @escaping getLocationCompletion) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationString) { (placemarks, error) in
            if error != nil {
                self.delegate.showAlert(withTitle: "Location error!", andMessage: "No location found for specified input")
                return
            }
            guard let placemarks = placemarks, let placemark = placemarks.first else {return}
            if let loc = placemark.location {
                completion(loc)
            }
        }
    }
}

// MARK: - Networking

extension EarthImageDataSource {
    private func getImage(forLocation loc: CLLocation) {
        self.imageView.image = nil
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        NasAPI.getEarthImage(forLocation: loc, withCloudScore: true) { (image, error) in
            if let error = error {
                self.delegate.showAlert(withTitle: "Networkign error!", andMessage: "Something went wrong while trying to get the image! Check your internet connection and try again")
                print("Error: \(error)")
            }
            guard let image = image else { return }
            var description = "\(self.locationName) at \(image.dateStr)"
            if let cloudScore = image.cloudScore {
                description += " with \(Int(cloudScore * 100))% clouds"
            }
            self.label.text = description
            image.getImage(completion: { (image, error) in
                if let error = error {
                    self.delegate.showAlert(withTitle: "Networkign error!", andMessage: "Something went wrong while trying to get the image! Check your internet connection and try again")
                    print("Image ERROR: \(error)")
                }
                guard let image = image else { return }
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
    }
}

