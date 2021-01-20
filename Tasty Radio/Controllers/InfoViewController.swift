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
import MessageUI
import PDFKit

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

extension InfoViewController: MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate {
    typealias EmailSupport = (recipient: String, subject: String)

    private func mail() {
        let recipient = "support@devlab.studio"
        let subject = "Tasty Radio"
        let body: EmailSupport = (recipient, subject)
        let clients = ThirdPartyMailClient.clients()
        var supportedClients: [ThirdPartyMailClient] = []
        let application = UIApplication.shared
        clients.forEach { client in
            if ThirdPartyMailer.application(application, isMailClientAvailable: client) {
                supportedClients.append(client)
            }
        }
        if supportedClients.isEmpty {
            openStandardComposer(body: body)
        }
        else {
            showChooseEmail(clients: supportedClients, body: body)
        }
    }
    
    private func showChooseEmail(clients: [ThirdPartyMailClient], body: EmailSupport) {
        let optionMenu = UIAlertController(title: nil, message: "Выберите почтовое приложение", preferredStyle: .actionSheet)
        optionMenu.view.tintColor = .dark2
        clients.forEach { client in
            let action = UIAlertAction(title: client.name, style: .default) { _ in
                self.showComposer(for: client, body: body)
            }
            optionMenu.addAction(action)
        }

        let action = UIAlertAction(title: "Apple Mail", style: .default) { _ in
            self.openStandardComposer(body: body)
        }
        optionMenu.addAction(action)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        optionMenu.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(optionMenu, animated: true, completion: nil)
        }
    }

    private func showComposer(for client: ThirdPartyMailClient, body: EmailSupport) {
        let message = "Я пользуюсь Tasty Radio:\n"
        let application = UIApplication.shared
        _ = ThirdPartyMailer.application(application, openMailClient: client, recipient: body.recipient, subject: body.subject, body: message)
    }

    private func openStandardComposer(body: EmailSupport) {
        let message = "Я пользуюсь Tasty Radio:\n"
        DispatchQueue.main.async { [weak self] in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([body.recipient])
                mail.setSubject(body.subject)
                mail.setMessageBody(message, isHTML: true)
                if let url = self?.info(), let data = try? Data(contentsOf: url) {
                    mail.addAttachmentData(data, mimeType: "application/pdf", fileName: "deviceInfo.pdf")
                }
                self?.present(mail, animated: true)
            }
            else {
                let message = """
                    Для возможности отправлять письма,
                    перейдите в настройки системы >
                    Пароли & Аккаунты > Добавить аккаунт.
                """
                let alertController = UIAlertController(title: "Задайте профиль почтового ящика", message: message, preferredStyle: .alert)
                alertController.view.tintColor = .dark2
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func info() -> URL? {
        let device = UIDevice.current
        let deviceModel = device.model
        let deviceName = device.name
        let systemName = device.systemName
        let systemVersion = device.systemVersion

        let locale = Locale.current
        let regionCode = locale.regionCode ?? ""
        let languageCode = locale.languageCode ?? ""
        
        let model = Device(
            deviceModel: deviceModel,
            deviceName: deviceName,
            systemName: systemName,
            systemVersion: systemVersion,
            regionCode: regionCode,
            languageCode: languageCode
        )
        
        let appName = Bundle.main.appName ?? ""
        let appVersion = Bundle.main.versionNumber ?? ""
        let appBuild = Bundle.main.buildNumber ?? ""
        
        let string = """
            
            APP: \(appName)
            APP VERSION: \(appVersion)
            BUILD: \(appBuild)

            ********** START DEVICE INFO **********
            [
                DEVICE: \(model.deviceModel)
                SYSTEM: \(model.systemName)
                SYS VERSION: \(model.systemVersion)
                REGION: \(model.regionCode)
            ]
            ********** END DEVICE INFO **********

        """
        
        return createPDF(for: string)
    }
    
    private func createPDF(for string: String) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "DEVICE INFO - Tasty Radio",
            kCGPDFContextAuthor: "devlab.studio"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = UIScreen.main.bounds.width
        let pageHeight = pageWidth
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
            ]
            let text = string
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("deviceInfo")
        let document = PDFDocument(data: data)
        let result = document?.write(to: destinationURL) ?? false
        if result {
            return destinationURL
        }
        return nil
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
