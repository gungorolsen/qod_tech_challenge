//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 28/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class CategoryServiceTests: XCTestCase {

    private var categoryService: CategoryRepo!
    private var mockHttpClient: MockHttpClient!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockHttpClient = MockHttpClient()
        categoryService = CategoryService(httpClient: mockHttpClient)
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockHttpClient = nil
        categoryService = nil
    }

    func testSuccessfulCall() throws {
        mockHttpClient.returnedResponse = MocksData.successfulCategoryResponse

        let expectation = self.expectation(description: "get categories")
        categoryService.getCategory().sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { response in
            XCTAssertEqual(response.categories, ["foo":"bar"])
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testMalformedCall() throws {
        mockHttpClient.returnedResponse = MocksData.malformedCategoryResponse

        let expectation = self.expectation(description: "get categories")
        categoryService.getCategory().sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { response in
            XCTAssertEqual(response.categories, [:])
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

    func testError() throws {
        let expectation = self.expectation(description: "get categories")
        categoryService.getCategory().sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { _ in
            XCTFail()
        }).store(in: &cancellables)
       
        waitForExpectations(timeout: 1)
    }

}

class MockHttpClient: HTTPClientType {

    var returnedResponse: Decodable?
    func dataTaskPublisher<T: Decodable>(urlString: String) -> AnyPublisher<T, HttpError> {
        if let returnedResponse = returnedResponse as? T {
            return Result<T, HttpError>.Publisher(.success(returnedResponse)).eraseToAnyPublisher()
        }
        return Fail(error: HttpError.invalidResponse).eraseToAnyPublisher()
    }
}
