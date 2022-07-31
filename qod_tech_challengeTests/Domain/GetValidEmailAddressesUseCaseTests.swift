//
//  GetValidEmailAddressesUseCaseTests.swift
//  qod_tech_challengeTests
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import XCTest
@testable import qod_tech_challenge

class GetValidEmailAddressesUseCaseTests: XCTestCase {

    private var useCase: GetValidEmailAddressesUseCase!

    override func setUpWithError() throws {
        useCase = GetValidEmailAddressesUseCaseImpl()
    }

    override func tearDownWithError() throws {
        useCase = nil
    }

    func testNil() throws {
        XCTAssertEqual(useCase.extractEmailAddresses(from: nil), [])
    }
    
    func testEmailAddresses() throws {
        let scenario1 = useCase.extractEmailAddresses(from: "foo@bar.com, olsen@gmail.com")
        XCTAssertEqual(scenario1, ["foo@bar.com", "olsen@gmail.com"])
        let scenario2 = useCase.extractEmailAddresses(from: " foo@bar.com,,,  olsen@gmail.com ")
        XCTAssertEqual(scenario2, ["foo@bar.com", "olsen@gmail.com"])
        let scenario3 = useCase.extractEmailAddresses(from: " foo@bar.com,, foo ,  olsen@gmail.com ")
        XCTAssertEqual(scenario3, ["foo@bar.com", "olsen@gmail.com"])
        let scenario4 = useCase.extractEmailAddresses(from: "  foo ,  ")
        XCTAssertEqual(scenario4, [])
    }

}
