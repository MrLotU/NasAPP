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
        
        let idLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        idLabel.textColor = .white
        idLabel.text = "Asteroid id: \(asteroids[index].id)"
        idLabel.sizeToFit()
        view.addSubview(idLabel)
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 0, height: 0))
        nameLabel.textColor = .white
        nameLabel.text = "Name: \(asteroids[index].name)"
        nameLabel.sizeToFit()
        view.addSubview(nameLabel)
        
        let dataLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        dataLabel.textColor = .white
        dataLabel.text = "Asteroid Data"
        dataLabel.sizeToFit()
        view.addSubview(dataLabel)
        
        let diameterLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 0, height: 0))
        diameterLabel.textColor = .white
        diameterLabel.text = "Diameter: \(asteroids[index].diameter) meters"
        diameterLabel.sizeToFit()
        view.addSubview(diameterLabel)
        
        let hazLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 0, height: 0))
        hazLabel.textColor = .white
        hazLabel.text = "Is potentially hazardous:"
        hazLabel.sizeToFit()
        view.addSubview(hazLabel)
        
        let hazvLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 0, height: 0))
        if asteroids[index].hazardous {hazvLabel.textColor = .red; hazvLabel.text = "YES"} else {hazvLabel.textColor = .green; hazvLabel.text = "NO"}
        hazvLabel.sizeToFit()
        view.addSubview(hazvLabel)
        
        let approachDataLabel = UILabel(frame: CGRect(x: 0, y: 180, width: 0, height: 0))
        approachDataLabel.textColor = .white
        approachDataLabel.textAlignment = .center
        approachDataLabel.text = "Approach Data\nDate: \(asteroids[index].approachData.date)\nSpeed: \(asteroids[index].approachData.relativeSpeed) kilometers per hour\nDistance: \(asteroids[index].approachData.distance) kilometers\nOrbiting body: \(asteroids[index].approachData.orbitingBody)"
        approachDataLabel.numberOfLines = 0
        approachDataLabel.sizeToFit()
        view.addSubview(approachDataLabel)
        
        let learnMoreButton = UIButton(frame: CGRect(x: 300, y: 0, width: 0, height: 0))
        learnMoreButton.titleLabel?.textColor = .white
        learnMoreButton.setTitle("Click here to read more", for: .normal)
        learnMoreButton.addTarget(self, action: #selector(learnMoreButtonPressed), for: .touchUpInside)
        learnMoreButton.sizeToFit()
        view.addSubview(learnMoreButton)

        return view
    }
    
    @objc func learnMoreButtonPressed() {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        delegate.open(url: asteroids[Int(currentPage)].jplUrl)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage)
    }
}

// MARK: - Networking

extension AsteroidDataSource {
    private func getAsteroids() {
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
            self.setupScrollView()
        }
    }
}
