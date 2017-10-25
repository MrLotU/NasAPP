//
//  SelectRoverImageViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 22/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class SelectRoverImageViewController: NasAPPViewController, ImagePickerDelegate {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!
    var delegate: ImagePickerDelegate!
    var image: UIImage!
    
    lazy var roverDataSource: RoverDataSource = {
        return RoverDataSource(collectionView: self.collectionView, delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = roverDataSource
        collectionView.delegate = roverDataSource
        collectionView.backgroundColor = .clear
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    func didFinishPickingImage(image: UIImage) {
        self.image = image
    }

    @objc func doneButtonPressed() {
        delegate.didFinishPickingImage(image: self.image)
        didPressHomeButton()
    }
}
