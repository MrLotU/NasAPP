//
//  AppDelegate.swift
//  NasAPP
//
//  Created by Jari Koopman on 09/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import NasAPI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set Nasa API key
        NasAPI.setApiKey("kGAYGkWiaqhzx1QY5Q1iuQWtQN17hVrCOjPJxN8W")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

