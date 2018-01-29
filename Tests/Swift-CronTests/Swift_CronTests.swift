import XCTest
@testable import SwiftCron

class Swift_CronTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(true, true)
    }


    static var allTests : [(String, (Swift_CronTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
