//
//  OnboardingViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {
    @IBAction private func onSkip(_ sender: UIButton) {
        guard
            let window = UIApplication.shared.windows.first else {
            return
        }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainViewController")
        let navigationController = NavigationController(rootViewController: controller)

        UIView.transition(with: window, duration: 0.4, options: [.transitionFlipFromLeft], animations: {
            window.rootViewController = navigationController
        }, completion: nil)
    }
}
