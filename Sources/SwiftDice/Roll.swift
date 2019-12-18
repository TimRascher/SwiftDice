//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public protocol Roll {
    var results: [RollResult] { get }
    var total: Int { get }
}
public func + (lhs: Roll, rhs: Roll) -> Roll {
    var results = lhs.results
    results.append(contentsOf: rhs.results)
    return DieRoll(total: lhs.total + rhs.total, results: results)
}
public func - (lhs: Roll, rhs: Roll) -> Roll {
    var results = lhs.results
    results.append(contentsOf: rhs.results)
    return DieRoll(total: lhs.total - rhs.total, results: results)
}
public func * (lhs: Roll, rhs: Roll) -> Roll {
    var results = lhs.results
    results.append(contentsOf: rhs.results)
    return DieRoll(total: lhs.total * rhs.total, results: results)
}
public func / (lhs: Roll, rhs: Roll) -> Roll {
    var results = lhs.results
    results.append(contentsOf: rhs.results)
    return DieRoll(total: lhs.total / rhs.total, results: results)
}

public struct DieRoll: Roll {
    public let results: [RollResult]
    public let total: Int
    public init(total: Int, results: [RollResult]) {
        self.results = results
        self.total = total
    }
    public init(_ value: Int) {
        results = [RollResult(sides: 0, value: value)]
        total = value
    }
    public init(_ die: Die) {
        var results = [RollResult]()
        var total = 0
        for _ in 0..<die.amount {
            let newResult = Int.random(in: 1...die.sides)
            results.append(RollResult(sides: die.sides, value: newResult))
            total += newResult
        }
        self.results = results
        self.total = total
    }
    public init() {
        self.init(Die())
    }
}

public struct RollResult {
    public let sides: Int
    public let value: Int
}
public extension Die {
    func roll() -> Roll { DieRoll(self) }
}
