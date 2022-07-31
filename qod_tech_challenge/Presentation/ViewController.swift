//
//  ViewController.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var indicator: UIActivityIndicatorView!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var button: UIButton!
    
    private var presenter: QuotePresenting!
    private var mailComposerRouter: MailComposerRouting!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = QuotePresenter(display: self)
        mailComposerRouter = MailComposerRouter(viewController: self)
    }

    @IBAction private func didTapButton() {
        presenter.emailQuoteOfTheDay(to: textView.text)
    }
}

extension ViewController: QuoteDisplay {
    func showSpinner() {
        indicator.isHidden = false
    }
    
    func hideSpinner() {
        indicator.isHidden = true
    }
    
    func showButton() {
        button.isHidden = false
    }
    
    func hideButton() {
        button.isHidden = true
    }

    func showMailComposer(subject: String, body: String, recipients: [String]) {
        do {
            try mailComposerRouter.showMailComposer(subject: subject, body: body, recipients: recipients)
        } catch {
            showErrorAlert(title: "Opps", message: "Mail composer not available")
        }
    }
}
