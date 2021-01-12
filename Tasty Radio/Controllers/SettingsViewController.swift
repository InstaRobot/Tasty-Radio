//
//  SettingsViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
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
