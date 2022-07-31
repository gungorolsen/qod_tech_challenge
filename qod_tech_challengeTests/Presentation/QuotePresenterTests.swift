//
//  QuotePresenterTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class QuotePresenterTests: XCTestCase {
    private var presenter: QuotePresenting!
    private var displaySpy: QuoteDisplaySpy!
    private var mockRandomQuoteUseCase: MockGetRandomQuoteUseCase!
    private var emailAddressesUseCaseSpy: GetValidEmailAddressesUseCaseSpy!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        displaySpy = QuoteDisplaySpy()
        mockRandomQuoteUseCase = MockGetRandomQuoteUseCase()
        emailAddressesUseCaseSpy = GetValidEmailAddressesUseCaseSpy()
        presenter = QuotePresenter(
            randomQuoteUseCase: mockRandomQuoteUseCase,
            emailAddressesUseCase: emailAddressesUseCaseSpy,
            display: displaySpy
        )
        cancellables = []
    }

    override func tearDownWithError() throws {
        displaySpy = nil
        mockRandomQuoteUseCase = nil
        presenter = nil
    }

    func testHappyPath() throws {
        let exp = expectation(description: "async expectations")

        mockRandomQuoteUseCase.returnedQuote = MocksData.successfulQuote
        presenter.emailQuoteOfTheDay(to: nil)

        XCTAssertTrue(displaySpy.isHideButtonCalled)
        XCTAssertTrue(displaySpy.isShowSpinnerCalled)

        DispatchQueue.main.async { exp.fulfill() }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(self.displaySpy.isShowMailComposerCalled)
        XCTAssertFalse(self.displaySpy.isShowErrorAlertCalled)
        XCTAssertEqual(self.displaySpy.mailSubject, "bar")
        XCTAssertEqual(self.displaySpy.mailBody, "\"foo\" \n\n by auth")
        XCTAssertTrue(self.displaySpy.isHideSpinnerCalled)
        XCTAssertTrue(self.displaySpy.isShowButtonCalled)
        XCTAssertTrue(self.emailAddressesUseCaseSpy.isExtractEmailAddressesCalled)
    }


    func testHappyPathWithNoAuthor() throws {
        let exp = expectation(description: "async expectations")

        mockRandomQuoteUseCase.returnedQuote = MocksData.successfulQuoteWithNoAuthor
        presenter.emailQuoteOfTheDay(to: nil)

        XCTAssertTrue(displaySpy.isHideButtonCalled)
        XCTAssertTrue(displaySpy.isShowSpinnerCalled)

        DispatchQueue.main.async { exp.fulfill() }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(self.displaySpy.isShowMailComposerCalled)
        XCTAssertFalse(self.displaySpy.isShowErrorAlertCalled)
        XCTAssertEqual(self.displaySpy.mailSubject, "bar")
        XCTAssertEqual(self.displaySpy.mailBody, "\"foo\" \n\n by Anonymous")
        XCTAssertTrue(self.displaySpy.isHideSpinnerCalled)
        XCTAssertTrue(self.displaySpy.isShowButtonCalled)
        XCTAssertTrue(self.emailAddressesUseCaseSpy.isExtractEmailAddressesCalled)
    }

    func testWhenGettingQuoteFails() throws {
        let exp = expectation(description: "async expectations")

        presenter.emailQuoteOfTheDay(to: nil)

        XCTAssertTrue(displaySpy.isHideButtonCalled)
        XCTAssertTrue(displaySpy.isShowSpinnerCalled)

        
        DispatchQueue.main.async { exp.fulfill() }
        waitForExpectations(timeout: 1)

        XCTAssertFalse(self.displaySpy.isShowMailComposerCalled)
        XCTAssertTrue(self.displaySpy.isShowErrorAlertCalled)
        XCTAssertEqual(self.displaySpy.alertMessage, "Something has gone wrong!")
        XCTAssertEqual(self.displaySpy.alertTitle, "Opps")
        XCTAssertTrue(self.displaySpy.isHideSpinnerCalled)
        XCTAssertTrue(self.displaySpy.isShowButtonCalled)
        XCTAssertFalse(self.emailAddressesUseCaseSpy.isExtractEmailAddressesCalled)
    }

}

final class QuoteDisplaySpy: QuoteDisplay {
    
    private(set) var isShowSpinnerCalled = false
    func showSpinner() {
        isShowSpinnerCalled = true
    }

    private(set) var isHideSpinnerCalled = false
    func hideSpinner() {
        isHideSpinnerCalled = true
    }

    private(set) var isShowButtonCalled = false
    func showButton() {
        isShowButtonCalled = true
    }

    private(set) var isHideButtonCalled = false
    func hideButton() {
        isHideButtonCalled = true
    }
    
    private(set) var isShowMailComposerCalled = false
    private(set) var mailSubject: String?
    private(set) var mailBody: String?
    private(set) var mailRecipients: [String]?
    func showMailComposer(subject: String, body: String, recipients: [String]) {
        isShowMailComposerCalled = true
        mailSubject = subject
        mailBody = body
        mailRecipients = recipients
    }

    private(set) var isShowErrorAlertCalled = false
    private(set) var alertTitle: String?
    private(set) var alertMessage: String?
    func showErrorAlert(title: String, message: String) {
        isShowErrorAlertCalled = true
        alertTitle = title
        alertMessage = message
    }
    
    private(set) var isEndEditingCalled = false
    func endEditing() {
        isEndEditingCalled = true
    }
}

final class MockGetRandomQuoteUseCase: GetRandomQuoteUseCase {
    var returnedQuote: Quote? 
    func getQuote() -> AnyPublisher<Quote, DomainError> {
        if let returnedQuote = returnedQuote {
            return Result<Quote, DomainError>.Publisher(.success(returnedQuote)).eraseToAnyPublisher()
        }
        return Fail(error: DomainError.noRandomCategory).eraseToAnyPublisher()
    }
}

final class GetValidEmailAddressesUseCaseSpy: GetValidEmailAddressesUseCase {

    private(set) var isExtractEmailAddressesCalled = false
    func extractEmailAddresses(from string: String?) -> [String] {
        isExtractEmailAddressesCalled = true
        return []
    }
}
