//
//  NasAPPTests.swift
//  NasAPPTests
//
//  Created by Jari Koopman on 09/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import XCTest
@testable import NasAPP
import NasAPI
import CoreLocation

class NasAPPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        NasAPI.setApiKey("kGAYGkWiaqhzx1QY5Q1iuQWtQN17hVrCOjPJxN8W")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRoverImageDownloading() {
        NasAPI.getImages(forRoverWithName: "Curiosity", andSol: 1000) { (images, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let images = images else { XCTFail("Didn't get images"); return }
            XCTAssert(images.count > 0, "Got back an empty image array")
        }
    }
    
    func testRoverImageValueDownloading() {
        NasAPI.getImages(forRoverWithName: "Curiosity", andSol: 1000) { (images, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let images = images else { XCTFail("Didn't get images"); return }
            if let image = images.first {
                image.getImage(completion: { (image, error) in
                    if let _ = error {
                        XCTFail("Got an error while downloading image")
                    }
                    guard let image = image else {XCTFail("Didn't get an image"); return}
                    XCTAssertNotNil(image, "Image is nil")
                })
            } else {
                XCTFail("Got an empty array")
            }
        }
    }
    
    func testAsteroidsDownloading() {
        NasAPI.getAsteroidDataForToday(detailed: false) { (asteroids, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let asteroids = asteroids else { XCTFail("Didn't get asteroids"); return }
            XCTAssert(asteroids.count > 0, "Got back an empty asteroid array")
        }
    }
    
    func testEarthAssetCreation() {
        let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
        NasAPI.getEarthImageAssets(forLocation: location) { (assets, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let assets = assets else { XCTFail("Didn't get assets"); return }
            XCTAssert(assets.count > 0, "Got back an empty asset array")
        }
    }
    
    func testEarthImageCreation() {
        let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
        NasAPI.getEarthImage(forLocation: location, withCloudScore: true) { (image, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let image = image else { XCTFail("Didn't get an image"); return }
            XCTAssertNotNil(image, "Image is nil")
        }
    }
    
    func testEarthImageValueDownload() {
        let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
        NasAPI.getEarthImage(forLocation: location, withCloudScore: true) { (image, error) in
            if let _ = error {
                XCTFail("Got back an error")
            }
            guard let image = image else { XCTFail("Didn't get an image"); return }
            image.getImage(completion: { (image, error) in
                if let _ = error {
                    XCTFail("Got back an error")
                }
                guard let image = image else { XCTFail("Didn't get an image"); return }
                XCTAssertNotNil(image, "Image is nil")
            })
        }
    }
    
}









