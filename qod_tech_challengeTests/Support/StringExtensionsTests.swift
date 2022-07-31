//
//  StringExtensionsTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import XCTest
@testable import qod_tech_challenge

class StringExtensionsTests: XCTestCase {


    func testIsValidEmail() throws {
        XCTAssertTrue("a@b.co".isValidEmail)
        XCTAssertTrue("olsen.gungor@suncorp.com.au".isValidEmail)
        XCTAssertFalse("olsen.gungor @suncorp.com.au".isValidEmail)
        XCTAssertFalse("123".isValidEmail)
        XCTAssertFalse("abc".isValidEmail)
        XCTAssertFalse("foo@bar".isValidEmail)
    }

    func testTrim() throws {
        XCTAssertEqual("foo".trimmed, "foo")
        XCTAssertEqual(" foo".trimmed, "foo")
        XCTAssertEqual("foo ".trimmed, "foo")
        XCTAssertEqual(" foo ".trimmed, "foo")
        XCTAssertEqual(" foo bar ".trimmed, "foo bar")
    }

}
