//
//  AppDelegate.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 05/07/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        Utility.setAuthAsRootViewController()
        
        return true
    }


}

