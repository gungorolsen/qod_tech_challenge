//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 28/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class QuoteMapperTests: XCTestCase {

    private var quoteMapper: QuoteMapping!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        quoteMapper = QuoteMapper()
        cancellables = []
    }

    override func tearDownWithError() throws {
        quoteMapper = nil
    }

    func testSuccessfulMap() throws {
        let domainObj = try? quoteMapper.mapToDomain(from: MocksData.successfulQuoteResponse)
        XCTAssertNotNil(domainObj)
        XCTAssertEqual(domainObj?.quote, "foo")
        XCTAssertEqual(domainObj?.title, "bar")
        XCTAssertEqual(domainObj?.author, "auth")
    }

    func testMalformedMap() throws {
        XCTAssertThrowsError(
            try quoteMapper.mapToDomain(from: MocksData.malformedQuoteResponse)
        )
    }
}
