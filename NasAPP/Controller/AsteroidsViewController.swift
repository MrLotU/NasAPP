//
//  AsteroidsViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 11/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class AsteroidsViewController: NasAPPViewController, AsteroidDelegate {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var dataSource: AsteroidDataSource = {
        return AsteroidDataSource(collectionView: self.collectionView, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        self.collectionView.delegate = dataSource
        self.collectionView.dataSource = dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
