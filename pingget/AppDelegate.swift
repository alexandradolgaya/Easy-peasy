//
//  AppDelegate.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/11/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3)
        MapsManager.initialize()
        return true
    }
}

