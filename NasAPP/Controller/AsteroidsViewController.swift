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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// Datasource for the asteroids
    lazy var dataSource: AsteroidDataSource = {
        return AsteroidDataSource(scrollView: self.scrollView, pageControl: self.pageControl, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        scrollView.delegate = dataSource
        dataSource.setup()
    }

    /// Opens an URL in the default web browser
    func open(url: String) {
        UIApplication.shared.open(URL(string: url)!, options: [:])
    }
}
