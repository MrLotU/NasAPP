//
//  AsteroidDataSource.swift
//  NasAPP
//
//  Created by Jari Koopman on 26/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import NasAPI

protocol AsteroidDelegate {
    
}

class AsteroidDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    private var asteroids: [Asteroid] = []
    var collectionView: UICollectionView
    var delegate: AsteroidDelegate
    
    init(collectionView: UICollectionView, delegate: AsteroidDelegate) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        self.getAsteroids()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asteroids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roverImageCell", for: indexPath)
        
        return cell
    }
}

// MARK: - Networking

extension AsteroidDataSource {
    @objc func getAsteroids() {
        NasAPI.getAsteroidDataForToday(detailed: false) { (asteroids, error) in
            if let error = error {
                //TODO: Handle
                print("ERROR: \(error)")
                return
            }
            guard let asteroids = asteroids else {
                print("Something went wrong!"); return
            }
            self.asteroids = asteroids
            print(self.asteroids.count)
            for asteroid in self.asteroids {
                print(asteroid.name)
            }
            self.collectionView.reloadData()
        }
    }
}
