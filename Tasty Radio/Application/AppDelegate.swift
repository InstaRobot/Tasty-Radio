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
        
        FRadioPlayer.shared.isAutoPlay = true
        FRadioPlayer.shared.enableArtwork = true
        FRadioPlayer.shared.artworkSize = 600
        return true
    }
    
    private func configureParseSubclasses() {
        ParseGenre.registerSubclass()
        ParseStation.registerSubclass()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    // MARK: - Remote Controls

    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        guard
            let event = event,
            event.type == .remoteControl else {
            return
        }
        
        switch event.subtype {
        case .remoteControlPlay:
            FRadioPlayer.shared.play()
        case .remoteControlPause:
            FRadioPlayer.shared.pause()
        case .remoteControlTogglePlayPause:
            FRadioPlayer.shared.togglePlaying()
//        case .remoteControlNextTrack:
//            stationsViewController?.didPressNextButton()
//        case .remoteControlPreviousTrack:
//            stationsViewController?.didPressPreviousButton()
        default:
            break
        }
    }
}

