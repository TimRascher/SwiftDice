import XCTest
@testable import SwiftDice

final class SwiftDiceTests: XCTestCase {
    static var allTests = [
        ("testDie", testDie),
        ("testRoll", testRoll),
        ("testAddition", testAddition),
        ("testSubtraction", testSubtraction),
        ("testMultiplication", testMultiplication),
        ("testDivision", testDivision),
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
    func testAddition() {
        let results = DiceExpressions.add(.die(try! Die("3d6")), .value(10)).roll()
        XCTAssertEqual(results.results.count, 4)
        for result in results.results {
            if result.sides != 0 {
                XCTAssertGreaterThanOrEqual(result.value, 1)
                XCTAssertLessThanOrEqual(result.value, 6)
            } else {
                XCTAssertEqual(result.value, 10)
            }
        }
        XCTAssertGreaterThanOrEqual(results.total, 15)
        XCTAssertLessThanOrEqual(results.total, 28)
    }
    func testSubtraction() {
        let results = DiceExpressions.subtract(.die(try! Die("3d6")), .value(10)).roll()
        XCTAssertEqual(results.results.count, 4)
        for result in results.results {
            if result.sides != 0 {
                XCTAssertGreaterThanOrEqual(result.value, 1)
                XCTAssertLessThanOrEqual(result.value, 6)
            } else {
                XCTAssertEqual(result.value, 10)
            }
        }
        XCTAssertGreaterThanOrEqual(results.total, -6)
        XCTAssertLessThanOrEqual(results.total, 8)
    }
    func testMultiplication() {
        let results = DiceExpressions.multiply(.die(try! Die("3d6")), .value(10)).roll()
        XCTAssertEqual(results.results.count, 4)
        for result in results.results {
            if result.sides != 0 {
                XCTAssertGreaterThanOrEqual(result.value, 1)
                XCTAssertLessThanOrEqual(result.value, 6)
            } else {
                XCTAssertEqual(result.value, 10)
            }
        }
        XCTAssertGreaterThanOrEqual(results.total, 30)
        XCTAssertLessThanOrEqual(results.total, 180)
    }
    func testDivision() {
        let results = DiceExpressions.devide(.die(try! Die("3d6")), .value(10)).roll()
        XCTAssertEqual(results.results.count, 4)
        for result in results.results {
            if result.sides != 0 {
                XCTAssertGreaterThanOrEqual(result.value, 1)
                XCTAssertLessThanOrEqual(result.value, 6)
            } else {
                XCTAssertEqual(result.value, 10)
            }
        }
        XCTAssertGreaterThanOrEqual(results.total, 0)
        XCTAssertLessThanOrEqual(results.total, 2)
    }
}
