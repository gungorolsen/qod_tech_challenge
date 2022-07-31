//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class GetRandomQuoteUseCaseTests: XCTestCase {

    private var useCase: GetRandomQuoteUseCase!
    private var mockQuoteService: MockQuoteService!
    private var mockCategoryService: MockCategoryService!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockQuoteService = MockQuoteService()
        mockCategoryService = MockCategoryService()
        useCase = GetRandomQuoteUseCaseImpl(
            categoryRepo: mockCategoryService,
            quoteRepo: mockQuoteService
        )
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockQuoteService = nil
        mockCategoryService = nil
        useCase = nil
    }

    func testHappyPath() throws {
        mockQuoteService.returnedQuote = MocksData.successfulQuote
        mockCategoryService.returnedCategory = MocksData.successfulCategory
        
        let expectation = self.expectation(description: "get qod from random category")
        useCase.getQuote().sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { quote in
            XCTAssertEqual(quote.quote, "foo")
            XCTAssertEqual(quote.title, "bar")
            XCTAssertEqual(quote.author, "auth")
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testWhenFetchingCategoryFails() throws {
        mockQuoteService.returnedQuote = MocksData.successfulQuote
        
        let expectation = self.expectation(description: "get qod from random category")
        useCase.getQuote().sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { quote in
            XCTFail()
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testWhenGettingRandomCategoryFails() throws {
        mockCategoryService.returnedCategory = MocksData.emptyCategory
        mockQuoteService.returnedQuote = MocksData.successfulQuote
        
        let expectation = self.expectation(description: "get qod from random category")
        useCase.getQuote().sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { quote in
            XCTFail()
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testWhenFetchingQuoteFails() throws {
        func testWhenGettingRandomCategoryFails() throws {
            mockCategoryService.returnedCategory = MocksData.successfulCategory
            
            let expectation = self.expectation(description: "get qod from random category")
            useCase.getQuote().sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { quote in
                XCTFail()
            }).store(in: &cancellables)
           
            waitForExpectations(timeout: 1)
        }
    }
}

class MockQuoteService: QuoteRepo {
    var returnedQuote: Quote?
    func getQuote(for categoryName: String) -> AnyPublisher<Quote, DomainError> {
        if let returnedQuote = returnedQuote {
            return Result<Quote, DomainError>.Publisher(.success(returnedQuote)).eraseToAnyPublisher()
        }
        return Fail(error: DomainError.noRandomCategory).eraseToAnyPublisher()
    }
}

class MockCategoryService: CategoryRepo {
    var returnedCategory: DomainCategory?
    func getCategory() -> AnyPublisher<DomainCategory, DomainError> {
        if let returnedCategory = returnedCategory {
            return Result<DomainCategory, DomainError>.Publisher(.success(returnedCategory)).eraseToAnyPublisher()
        }
        return Fail(error: DomainError.noRandomCategory).eraseToAnyPublisher()
    }
}

typealias DomainCategory = qod_tech_challenge.Category
