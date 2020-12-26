//
//  InfoViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.dark6.cgColor
            containerView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            let text = "Приложение разработано при участии: \n\n Никита Минаков \n Айрат Мингазов \n Александр Харитонов"
            infoLabel.text = text
            
            infoLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var appVersionLabel: UILabel! {
        didSet {
            if let appName = Bundle.main.appName, let version = Bundle.main.versionNumber, let build = Bundle.main.buildNumber {
                let text = appName.appending(", ").appending(version).appending(".").appending(build)
                appVersionLabel.text = text
            }
        }
    }
 
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
