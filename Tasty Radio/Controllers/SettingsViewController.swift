//
//  SettingsViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var groupView1: UIView! {
        didSet {
            groupView1.layer.borderWidth = 1
            groupView1.layer.borderColor = UIColor.dark6.cgColor
            groupView1.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var groupView2: UIView! {
        didSet {
            groupView2.layer.borderWidth = 1
            groupView2.layer.borderColor = UIColor.dark6.cgColor
            groupView2.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var groupTitle1: UILabel! {
        didSet {
            groupTitle1.text = "Кеш приложения"
        }
    }
    @IBOutlet weak var groupTitle2: UILabel! {
        didSet {
            groupTitle2.text = "Избранное пользователя"
        }
    }

    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearCache() {
        
    }
    
    @IBAction func clearFavourites() {
        
    }
    
    
    private func loadSettings() {
        
    }
}
