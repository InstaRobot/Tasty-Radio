//
//  LaunchManager.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class LaunchManager {
    
    private var window: UIWindow?
    
    private var launch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "launch")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "launch")
        }
    }
    
    func createWindow(window: UIWindow?) {
        self.window = window
//        launch = false
        
        if launch {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainController")
            let navigationController = NavigationController(rootViewController: controller)
            window?.rootViewController = navigationController
        }
        else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "onboardingController")
            let navigationController = NavigationController(rootViewController: controller)
            window?.rootViewController = navigationController
            launch = true
        }
        window?.makeKeyAndVisible()
    }
    
}
