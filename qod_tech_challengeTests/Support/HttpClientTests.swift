//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 28/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class HttpClientTests: XCTestCase {

    let testTimeout: TimeInterval = 1

    var mockUrlSessionProvider: MockURLSessionProvider!
    var client: HTTPClient!
    
    override func setUpWithError() throws {
        mockUrlSessionProvider = MockURLSessionProvider()
        client = HTTPClient(urlSessionProvider: mockUrlSessionProvider)
    }

    override func tearDownWithError() throws {
        mockUrlSessionProvider = nil
        client = nil
    }

    func testSuccessfulCall() throws {
        let publisher: AnyPublisher<QuoteResponse, HttpError> = client.dataTaskPublisher(urlString: "http://google.com")
        URLProtocolMock.returnedData = "{}".data(using: .utf8)
        
        URLProtocolMock.response = MocksData.validResponse

        // Test the Publisher
        let validTest = evalValidResponseTest(publisher: publisher)
        wait(for: validTest.expectations, timeout: testTimeout)
        validTest.cancellable?.cancel()
    }

    func testUnsuccessfulCall() throws {
        let publisher: AnyPublisher<QuoteResponse, HttpError> = client.dataTaskPublisher(urlString: "http://google.com")
        URLProtocolMock.returnedData = "{}".data(using: .utf8)
        
        URLProtocolMock.response = MocksData.invalidResponse

        // Test the Publisher
        let validTest = evalInvalidResponseTest(publisher: publisher)
        wait(for: validTest.expectations, timeout: testTimeout)
        validTest.cancellable?.cancel()
    }

    func testMalformedUrl() throws {
        let publisher: AnyPublisher<QuoteResponse, HttpError> = client.dataTaskPublisher(urlString: "ff ff")
        URLProtocolMock.returnedData = "{}".data(using: .utf8)
        
        URLProtocolMock.response = MocksData.validResponse

        // Test the Publisher
        let invalidTest = evalInvalidResponseTest(publisher: publisher)
        wait(for: invalidTest.expectations, timeout: testTimeout)
        invalidTest.cancellable?.cancel()
    }

    
    func evalValidResponseTest<T:Publisher>(publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
           XCTAssertNotNil(publisher)
           
           let expectationFinished = expectation(description: "finished")
           let expectationReceive = expectation(description: "receiveValue")
           let expectationFailure = expectation(description: "failure")
           expectationFailure.isInverted = true
           
           let cancellable = publisher?.sink (receiveCompletion: { (completion) in
               switch completion {
               case .failure(let error):
                   print(error)
                   expectationFailure.fulfill()
               case .finished:
                   expectationFinished.fulfill()
               }
           }, receiveValue: { response in
               XCTAssertNotNil(response)
               print(response)
               expectationReceive.fulfill()
           })
           return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                   cancellable: cancellable)
       }
       
       func evalInvalidResponseTest<T:Publisher>(publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
           XCTAssertNotNil(publisher)
           
           let expectationFinished = expectation(description: "Invalid.finished")
           expectationFinished.isInverted = true
           let expectationReceive = expectation(description: "Invalid.receiveValue")
           expectationReceive.isInverted = true
           let expectationFailure = expectation(description: "Invalid.failure")
           
           let cancellable = publisher?.sink (receiveCompletion: { (completion) in
               switch completion {
               case .failure(let error):
                   print(error)
                   expectationFailure.fulfill()
               case .finished:
                   expectationFinished.fulfill()
               }
           }, receiveValue: { response in
               XCTAssertNotNil(response)
               print(response)
               expectationReceive.fulfill()
           })
            return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                          cancellable: cancellable)
       }
}

class MockURLSessionProvider: URLSessionProviding {
        
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        return URLSession.DataTaskPublisher(request: URLRequest(url: url),
                                            session: session)
    }
}

// https://betterprogramming.pub/swift-unit-test-a-datataskpublisher-with-urlprotocol-2fbda186758e
@objc class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var returnedData: Data?
    static var response: URLResponse?
    static var error: Error?
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = URLProtocolMock.returnedData {
            // …load? immediately.
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolMock.response {
            self.client?.urlProtocol(self,
                                     didReceive: response,
                                     cacheStoragePolicy: .notAllowed)
        }
        
        // …and we return our error if defined…
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

final class MocksData {
    
    static let successfulCategoryResponse = CategoryResponse(contents: .init(categories: ["foo":"bar"]))
    static let malformedCategoryResponse = CategoryResponse(contents: nil)
    static let successfulQuoteResponse = QuoteResponse(contents: .init(quotes:
                                        [.init(quote: "foo", title: "bar", author: "auth")]))
    static let malformedQuoteResponse = QuoteResponse(contents: nil)

    static let successfulQuote = Quote(quote: "foo", title: "bar", author: "auth")
    static let successfulQuoteWithNoAuthor = Quote(quote: "foo", title: "bar", author: nil)
    static let successfulCategory = Category(categories: ["foo":"bar"])
    static let emptyCategory = Category(categories: [:])

    static let invalidResponse = URLResponse(url: URL(string: "http://localhost:8080")!,
                                             mimeType: nil,
                                             expectedContentLength: 0,
                                             textEncodingName: nil)
    static let validResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
}
