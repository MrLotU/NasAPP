//
//  RoverDataSource.swift
//  NasAPP
//
//  Created by Jari Koopman on 23/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import NasAPI

class RoverDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate var images: [UIImage] = []
    
    override init() {
        super.init()
        self.getImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roverImageCell", for: indexPath)
        
        return cell
    }
}

//MARK: - Networking

extension RoverDataSource {
    func getImages() {
        NasAPI.getImages(forRoverWithName: "Curiosity", andSol: 1000, completion: { (images, error) in
            if let error = error {
                print(error)
                print("Error")
                return
                //TODO: Handle error
            }
            guard let images = images else {
                return
            }
            for image in images {
                print(image.id)
            }
            print(images.count)
        })
    }
}
