//
//  SettingsViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.

import UIKit

final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.addObserver(
            self,
            forKeyPath: "display_preference",
            options: .new,
            context: nil
        )
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "display_preference" {
            self.updateSettings()
        }
    }
    
    private func updateSettings() {
        let overrideDisplaySettings = UserDefaults.standard.bool(forKey: "display_preference")
        if overrideDisplaySettings {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    @IBAction private func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController {
    static func make() -> SettingsViewController? {
        if let controller = UIStoryboard(
            name: "Main",
            bundle: .none
        ).instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController {
            return controller
        }
        return .none
    }
}
