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

class AsteroidDataSource: NSObject {
    private var asteroids: [Asteroid] = []
    var collectionView: UICollectionView
    var delegate: AsteroidDelegate
    
    init(collectionView: UICollectionView, delegate: AsteroidDelegate) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        self.getAsteroids()
    }
}

// MARK: - Networking

extension AsteroidDataSource {
    @objc func getAsteroids() {
        
    }
}
