import XCTest
@testable import PerfectQiniu

final class PerfectQiniuTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PerfectQiniu().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
