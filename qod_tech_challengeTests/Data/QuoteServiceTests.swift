//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 28/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class QuoteServiceTests: XCTestCase {

    private var quoteService: QuoteRepo!
    private var mockHttpClient: MockHttpClient!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockHttpClient = MockHttpClient()
        quoteService = QuoteService(httpClient: mockHttpClient)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockHttpClient = nil
        quoteService = nil
    }

    func testSuccessfulCall() throws {
        mockHttpClient.returnedResponse = MocksData.successfulQuoteResponse

        let expectation = self.expectation(description: "get quote")
        quoteService.getQuote(for: "foobar").sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { response in
            XCTAssertEqual(response.quote, "foo")
            XCTAssertEqual(response.author, "auth")
            XCTAssertEqual(response.title, "bar")
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testMalformedCall() throws {
        mockHttpClient.returnedResponse = MocksData.malformedQuoteResponse

        let expectation = self.expectation(description: "get quote")
        quoteService.getQuote(for: "foobar").sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { response in
            XCTFail()
        }).store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }

    func testError() throws {
        let expectation = self.expectation(description: "get quote")
        quoteService.getQuote(for: "foobar").sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { _ in
            XCTFail()
        }).store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }

}
