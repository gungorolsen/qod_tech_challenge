//
//  QuoteDisplay.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

protocol QuoteDisplay: AlertDisplaying, EndEditing {
    func showSpinner()
    func hideSpinner()
    func showButton()
    func hideButton()
    func showMailComposer(subject: String, body: String, recipients: [String])
}
