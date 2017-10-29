//
//  AsteroidDataSource.swift
//  NasAPP
//
//  Created by Jari Koopman on 26/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import NasAPI

protocol AsteroidDelegate: AlertDelegate {
    func open(url: String)
}

class AsteroidDataSource: NSObject {
    private var asteroids: [Asteroid] = []
    var scrollView: UIScrollView
    var delegate: AsteroidDelegate
    var pageControl: UIPageControl
    
    init(scrollView: UIScrollView, pageControl: UIPageControl, delegate: AsteroidDelegate) {
        self.scrollView = scrollView
        self.delegate = delegate
        self.pageControl = pageControl
    }
    
    func setup() {
        self.getAsteroids()
    }
}

// MARK: - Scrollview setup

extension AsteroidDataSource: UIScrollViewDelegate {
    private func setupScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(asteroids.count), height: scrollView.frame.height)
        pageControl.numberOfPages = asteroids.count
        pageControl.currentPage = 0
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        for i in 0..<asteroids.count {
            scrollView.addSubview(setupScrollviewPage(atIndex: i))
        }
    }
    
    private func setupScrollviewPage(atIndex index: Int) -> UIView {
        let scrollViewWidth = scrollView.frame.width
        let view = UIView(frame: CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
        
        let idLabel = UILabel(frame: CGRect(x: 0, y: 238-172, width: 0, height: 0))
        idLabel.textColor = .white
        idLabel.font = UIFont(name: idLabel.font.fontName, size: 30.0)
        idLabel.text = "Asteroid id: \(asteroids[index].id)"
        idLabel.sizeToFit()
        view.addSubview(idLabel)
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 274-172, width: 0, height: 0))
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: nameLabel.font.fontName, size: 30.0)
        nameLabel.text = "Name: \(asteroids[index].name)"
        nameLabel.sizeToFit()
        view.addSubview(nameLabel)
        
        let dataLabel = UILabel(frame: CGRect(x: 0, y: 353-172, width: 0, height: 0))
        dataLabel.textColor = .white
        dataLabel.font = UIFont(name: dataLabel.font.fontName, size: 30.0)
        dataLabel.text = "Asteroid Data"
        dataLabel.sizeToFit()
        view.addSubview(dataLabel)
        
        let diameterLabel = UILabel(frame: CGRect(x: 0, y: 399-172, width: 0, height: 0))
        diameterLabel.textColor = .white
        diameterLabel.font = UIFont(name: diameterLabel.font.fontName, size: 30.0)
        diameterLabel.text = "Diameter: \(asteroids[index].diameter) meters"
        diameterLabel.sizeToFit()
        view.addSubview(diameterLabel)
        
        let hazLabel = UILabel(frame: CGRect(x: 0, y: 446-172, width: 0, height: 0))
        hazLabel.textColor = .white
        hazLabel.font = UIFont(name: hazLabel.font.fontName, size: 30.0)
        hazLabel.text = "Is potentially hazardous:"
        hazLabel.sizeToFit()
        view.addSubview(hazLabel)
        
        let hazvLabel = UILabel(frame: CGRect(x: 0, y: 491-172, width: 0, height: 0))
        if asteroids[index].hazardous {hazvLabel.textColor = .red; hazvLabel.text = "YES"} else {hazvLabel.textColor = .green; hazvLabel.text = "NO"}
        hazvLabel.font = UIFont(name: hazvLabel.font.fontName, size: 30.0)
        hazvLabel.sizeToFit()
        view.addSubview(hazvLabel)
        
        let approachDataLabel = UILabel(frame: CGRect(x: 0, y: 570-172, width: 0, height: 0))
        approachDataLabel.textColor = .white
        approachDataLabel.font = UIFont(name: approachDataLabel.font.fontName, size: 30.0)
        approachDataLabel.textAlignment = .center
        approachDataLabel.text = "Approach Data\nDate: \(asteroids[index].approachData.dateStr)\nSpeed: \(asteroids[index].approachData.relativeSpeed) kilometers per hour\nDistance: \(asteroids[index].approachData.distance) kilometers\nOrbiting body: \(asteroids[index].approachData.orbitingBody)"
        approachDataLabel.numberOfLines = 0
        approachDataLabel.sizeToFit()
        view.addSubview(approachDataLabel)
        
        let learnMoreButton = UIButton(frame: CGRect(x: 0, y: 863-172, width: 0, height: 0))
        learnMoreButton.titleLabel?.textColor = .white
        learnMoreButton.titleLabel?.font = UIFont(name: (learnMoreButton.titleLabel?.font.fontName)!, size: 30.0)
        learnMoreButton.setTitle("Click here to read more", for: .normal)
        learnMoreButton.addTarget(self, action: #selector(learnMoreButtonPressed), for: .touchUpInside)
        learnMoreButton.sizeToFit()
        view.addSubview(learnMoreButton)
        
        for subview in view.subviews {
            subview.center.x = view.frame.width/2
        }
        return view
    }
    
    /// Tells the delegate to open the specified URL in a web browser
    @objc func learnMoreButtonPressed() {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        delegate.open(url: asteroids[Int(currentPage)].jplUrl)
    }

    /// Updates the page control
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage)
    }
}

// MARK: - Networking

extension AsteroidDataSource {
    /// Calls the NasAPI to get asteroids for today
    func getAsteroids() {
        NasAPI.getAsteroidDataForToday(detailed: false) { (asteroids, error) in
            if let error = error {
                self.delegate.showAlert(withTitle: "Networkign error!", andMessage: "Something went wrong while trying to get the asteroid data! Check your internet connection and try again")
                print("ERROR: \(error)")
                return
            }
            guard let asteroids = asteroids else { return }
            self.asteroids = asteroids
            self.setupScrollView()
        }
    }
}
