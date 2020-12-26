//
//  AppDelegate.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/21/20.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        LaunchManager().createWindow(window: window)
        
        configureParseSubclasses()
        Parse.initialize(with: ConfigParse().config())
        
        CloudKitService.shared.fetchStationsFromCloud()
        return true
    }
    
    private func configureParseSubclasses() {
        ParseGenre.registerSubclass()
        ParseStation.registerSubclass()
    }

}

