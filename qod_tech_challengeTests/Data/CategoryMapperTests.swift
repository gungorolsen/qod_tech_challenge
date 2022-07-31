//
//  HttpClientTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 28/7/2022.
//

import XCTest
import Combine
@testable import qod_tech_challenge

class CategoryMapperTests: XCTestCase {

    private var categoryMapper: CategoryMapping!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        categoryMapper = CategoryMapper()
        cancellables = []
    }

    override func tearDownWithError() throws {
        categoryMapper = nil
    }

    func testSuccessfulMap() throws {
        let domainObj = try? categoryMapper.mapToDomain(from: MocksData.successfulCategoryResponse)
        XCTAssertNotNil(domainObj)
        XCTAssertEqual(domainObj?.categories, ["foo":"bar"])
    }

    func testMalformedMap() throws {
        XCTAssertThrowsError(
            try categoryMapper.mapToDomain(from: MocksData.malformedCategoryResponse)
        )
    }
}
