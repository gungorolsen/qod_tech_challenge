//
//  MailComposerRouter.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import MessageUI
import UIKit

protocol MailComposerRouting {
    func showMailComposer(subject: String, body: String, recipients: [String]) throws
}

class MailComposerRouter: NSObject {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension MailComposerRouter: MailComposerRouting {
    
    func showMailComposer(subject: String, body: String, recipients: [String]) throws {
        guard MFMailComposeViewController.canSendMail() else {
            throw NSError()
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        mailComposer.setToRecipients(recipients)
        viewController.present(mailComposer, animated: true)
    }
}

extension MailComposerRouter: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
