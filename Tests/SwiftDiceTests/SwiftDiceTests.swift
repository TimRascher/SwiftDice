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
        ("testExpression", testExpression),
        ("testNotationWithOptionalDiceAmount", testNotationWithOptionalDiceAmount),
        ("testFlagCodable", testFlagCodable),
        ("testExpressionCodable", testExpressionCodable),
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
            XCTAssertEqual(error as! SwiftDiceErrors, SwiftDiceErrors.unableToConvertToDie("These Dice Are Neat"))
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
        XCTAssert(check(results))
    }
    func testAddition() {
        let results = DiceExpressions.add(.die(try! Die("3d6")), .number(10)).roll()
        XCTAssert(check(results, in: 15...28))
    }
    func testSubtraction() {
        let results = DiceExpressions.subtract(.die(try! Die("3d6")), .number(10)).roll()
        XCTAssert(check(results, in: -6...8))
    }
    func testMultiplication() {
        let results = DiceExpressions.multiply(.die(try! Die("3d6")), .number(10)).roll()
        XCTAssert(check(results, in: 30...180))
    }
    func testDivision() {
        let results = DiceExpressions.devide(.die(try! Die("3d6")), .number(10)).roll()
        XCTAssert(check(results, in: 0...2))
    }
    func testExpression() {
        let expression = try? DiceExpressions("(2d10 + 10) * 10")
        let results = expression?.roll()
        XCTAssert(check(results, in: 120...300, numberOfDice: 2, diceRange: 1...10))
    }
    func testNotationWithOptionalDiceAmount() {
        let expression = try? DiceExpressions("d10")
        let results = expression?.roll()
        XCTAssert(check(results, in: 1...10, numberOfDice: 1, diceRange: 1...10))
    }
    func testFlagCodable() {
        let flag = DieFlags.keep(10)
        guard let json = try? JSONEncoder().encode(flag), let string = String(data: json, encoding: .utf8) else {
            XCTAssert(false)
            return
        }
        print(string)
        let fromJSON = try? JSONDecoder().decode(DieFlags.self, from: json)
        XCTAssertEqual(fromJSON, DieFlags.keep(10))
    }
    func testExpressionCodable() {
        let expression = try! DiceExpressions("(2d10! + 10) * 10")
        guard let json = try? JSONEncoder().encode(expression), let string = String(data: json, encoding: .utf8) else {
            XCTAssert(false)
            return
        }
        print(string)
        let fromJSON = try! JSONDecoder().decode(DiceExpressions.self, from: json)
        XCTAssertEqual(fromJSON, expression)
    }
}
extension SwiftDiceTests {
    func check(_ results: Roll?, in range: ClosedRange<Int> = 3...18, numberOfDice: Int = 3, diceRange: ClosedRange<Int> = 1...6) -> Bool {
        guard let results = results else { return false }
        var check = true
        func append(_ bool: Bool) { check = check && bool }
        append(results.results.count == numberOfDice)
        for result in results.results {
            append(result.value >= diceRange.first!)
            append(result.value <= diceRange.last!)
        }
        append(results.total >= range.first!)
        append(results.total <= range.last!)
        return check
    }
}
