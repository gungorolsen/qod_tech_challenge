//
//  QuotePresenter.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Combine
import UIKit

protocol QuotePresenting {
    func emailQuoteOfTheDay(to recipients: String?)
}

class QuotePresenter {
    private let randomQuoteUseCase: GetRandomQuoteUseCase
    private let emailAddressesUseCase: GetValidEmailAddressesUseCase
    private let display: QuoteDisplay

    private var cancellables: [AnyCancellable] = []

    init(randomQuoteUseCase: GetRandomQuoteUseCase = GetRandomQuoteUseCaseImpl(),
         emailAddressesUseCase: GetValidEmailAddressesUseCase = GetValidEmailAddressesUseCaseImpl(),
         display: QuoteDisplay) {
        self.randomQuoteUseCase = randomQuoteUseCase
        self.emailAddressesUseCase = emailAddressesUseCase
        self.display = display
    }
}

extension QuotePresenter: QuotePresenting {
    func emailQuoteOfTheDay(to recipients: String?) {
        prepareDisplayForServiceCall()
        cleanupCancellables()
        
        randomQuoteUseCase.getQuote()
            .receive(on: RunLoop.main)
            .map(QuoteEmailViewModel.init)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] in
                self?.didRetrieveQuote($0, recipients: recipients)
            }
            .store(in: &cancellables)
    }
}


private extension QuotePresenter {
    
    func cleanupCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func prepareDisplayForServiceCall() {
        display.hideButton()
        display.showSpinner()
        display.endEditing()
    }
    
    func resetDisplayForServiceCall() {
        display.showButton()
        display.hideSpinner()
    }
    
    func didRetrieveQuote(_ quote: QuoteEmailViewModel, recipients: String?) {
        resetDisplayForServiceCall()
        let validEmails = emailAddressesUseCase.extractEmailAddresses(from: recipients)
        display.showMailComposer(subject: quote.subject,
                                 body: quote.body,
                                 recipients: validEmails)
    }
    
    func handleError(_ error: Error) {
        resetDisplayForServiceCall()
        display.showErrorAlert(title: "Opps", message: "Something has gone wrong!")
    }
}
