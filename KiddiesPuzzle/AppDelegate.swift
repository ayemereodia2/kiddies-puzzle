//
//  AppDelegate.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let menuViewController = MenuViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = menuViewController
        window?.makeKeyAndVisible()
        return true
    }

}

