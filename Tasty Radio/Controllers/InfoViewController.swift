//
//  InfoViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Lottie

class InfoViewController: UIViewController {
    @IBOutlet private(set) weak var musicAnimationView: AnimationView!
    @IBOutlet private(set) weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.dark6.cgColor
            containerView.layer.cornerRadius = 10
        }
    }
    @IBOutlet private(set) weak var logoImageView: UIImageView!
    @IBOutlet private(set) weak var infoLabel: UILabel! {
        didSet {
            let text = "Приложение разработано при участии: \n\n Никита Минаков \n Айрат Мингазов \n Александр Харитонов"
            infoLabel.text = text
            
            infoLabel.numberOfLines = 0
        }
    }
    @IBOutlet private(set) weak var appVersionLabel: UILabel! {
        didSet {
            if let appName = Bundle.main.appName, let version = Bundle.main.versionNumber, let build = Bundle.main.buildNumber {
                let text = appName.appending(", ").appending(version).appending(".").appending(build)
                appVersionLabel.text = text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopAnimation()
    }
 
    @IBAction private func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InfoViewController {
    private func startAnimation() {
        musicAnimationView.loopMode = .loop
        musicAnimationView.animationSpeed = 0.5
        musicAnimationView.frame = .zero
        musicAnimationView.contentMode = .scaleAspectFit
        musicAnimationView.play()
    }

    private func stopAnimation() {
        musicAnimationView.stop()
    }
}

extension InfoViewController {
    static func make() -> InfoViewController? {
        if let controller = UIStoryboard(
            name: "Main",
            bundle: .none
        ).instantiateViewController(identifier: "InfoViewController") as? InfoViewController {
            return controller
        }
        return .none
    }
}
