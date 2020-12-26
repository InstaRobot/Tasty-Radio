//
//  OnboardingViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBAction func onSkip(_ sender: UIButton) {
        guard
            let window = UIApplication.shared.windows.first else {
            return
        }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainController")
        let navigationController = NavigationController(rootViewController: controller)

        UIView.transition(with: window, duration: 0.4, options: [.transitionFlipFromLeft], animations: {
            window.rootViewController = navigationController
        }, completion: nil)
    }
}
