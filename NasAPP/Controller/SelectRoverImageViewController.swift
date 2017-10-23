//
//  SelectRoverImageViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 22/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit

class SelectRoverImageViewController: NasAPPViewController {
    
    var delegate: ImagePickerDelegate!
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didPressHomeButton() {
        delegate.didFinishPickingImage(image: image)
        super.didPressHomeButton()
    }
}
