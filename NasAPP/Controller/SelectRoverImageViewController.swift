//
//  SelectRoverImageViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 22/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class SelectRoverImageViewController: NasAPPViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!
    var delegate: ImagePickerDelegate!
    var image: UIImage!
    
    lazy var roverDataSource: RoverDataSource = {
       return RoverDataSource()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = roverDataSource
        collectionView.delegate = roverDataSource
    }
    
    override func didPressHomeButton() {
        delegate.didFinishPickingImage(image: image)
        super.didPressHomeButton()
    }
}
