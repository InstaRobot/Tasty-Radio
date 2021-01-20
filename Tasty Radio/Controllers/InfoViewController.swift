//
//  InfoViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Lottie
import ThirdPartyMailer

final class InfoViewController: UIViewController {
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
    
    @IBAction private func onMail(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            self?.mail()
        }
    }
    
}

extension InfoViewController {
    private func mail() {
        let clients = ThirdPartyMailClient.clients()
        var supportedClients: [ThirdPartyMailClient] = []
        let application = UIApplication.shared
        clients.forEach { client in
            if ThirdPartyMailer.application(application, isMailClientAvailable: client) {
                supportedClients.append(client)
            }
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Выберите почтовую программу",
                                           preferredStyle: .actionSheet)
        optionMenu.view.tintColor = .dark1
        supportedClients.forEach { client in
            let action = UIAlertAction(title: client.name, style: .default) { _ in
                _ = ThirdPartyMailer.application(application, openMailClient: client)
            }
            optionMenu.addAction(action)
        }
        
        let action = UIAlertAction(title: "Apple Mail", style: .default) { _ in
            if let url = URL(string: "message://"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        optionMenu.addAction(action)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        optionMenu.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(optionMenu, animated: true, completion: nil)
        }
    }
    
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
