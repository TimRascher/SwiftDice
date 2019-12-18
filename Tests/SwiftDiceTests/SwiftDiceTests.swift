import XCTest
@testable import SwiftDice

final class SwiftDiceTests: XCTestCase {
    static var allTests = [
        ("testDie", testDie),
        ("testRoll", testRoll),
    ]
}
extension SwiftDiceTests {
    func testDie() {
        let testString = "3d6"
        XCTAssertEqual(String(try! Die(amount: 3, sides: 6)), testString)
        XCTAssertEqual(String(try! Die(testString)), testString)
        XCTAssertThrowsError(try Die("blamo")) { (error) in
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.unableToConvertToDie("blamo"))
        }
        XCTAssertThrowsError(try Die("These Dice Are Neat!")) { (error) in
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.unableToConvertToDie("These Dice Are Neat!"))
        }
        XCTAssertThrowsError(try Die(amount: -1, sides: 6)) { (error) in
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.valuesCannotBeNegitive(-1, 6))
        }
        XCTAssertThrowsError(try Die(amount: 1, sides: -6)) { (error) in
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.valuesCannotBeNegitive(1, -6))
        }
        XCTAssertThrowsError(try Die(amount: -1, sides: -6)) { (error) in
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.valuesCannotBeNegitive(-1, -6))
        }
    }
    func testRoll() {
        let results = try! Die(amount: 3, sides: 6).roll()
        XCTAssertEqual(results.results.count, 3)
        for result in results.results {
            XCTAssertGreaterThanOrEqual(result.value, 1)
            XCTAssertLessThanOrEqual(result.value, 6)
        }
        XCTAssertGreaterThanOrEqual(results.total, 3)
        XCTAssertLessThanOrEqual(results.total, 18)
    }
}
