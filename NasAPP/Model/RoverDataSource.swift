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
    let collectionView: UICollectionView
    let delegate: ImagePickerDelegate
    
    init(collectionView: UICollectionView, delegate: ImagePickerDelegate) {
        self.delegate = delegate
        self.collectionView = collectionView
        super.init()
        self.getImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RoverImageCollectionViewCell
        delegate.didFinishPickingImage(image: cell.image!)
        cell.backgroundColor = .green
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RoverImageCollectionViewCell
        cell.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roverImageCell", for: indexPath) as! RoverImageCollectionViewCell
        let image = images[indexPath.row]
        cell.image = image
        cell.backgroundColor = .clear
        
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
                image.getImage(completion: { (image, error) in
                    if let error = error {
                        print("ERROR: \(error)")
                    }
                    if let image = image {
                        self.images.append(image)
                        self.collectionView.reloadData()
                        print(self.images.count)
                    }
                })
            }
        })
    }
}
