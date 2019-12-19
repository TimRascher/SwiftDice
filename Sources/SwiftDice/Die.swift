//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public struct Die {
    public let amount: Int
    public let sides: Int
    public let flags: Set<DieFlags>
    public init() {
        self.amount = 1
        self.sides = 6
        self.flags = Set<DieFlags>()
    }
    public init(amount: Int, sides: Int, flags: [DieFlags]) throws {
        self = try Die(amount: amount, sides: sides, flags: Set(flags))
    }
    public init(amount: Int, sides: Int, flags: Set<DieFlags> = Set<DieFlags>()) throws {
        guard amount > 0, sides > 0 else { throw SwiftDiceErrors.valuesCannotBeNegitive(amount, sides) }
        self.amount = amount
        self.sides = sides
        self.flags = flags
    }
}
extension Die: Equatable { }
extension Die: Hashable { }
extension Die: Codable { }
public extension Die {
    init(_ string: String) throws {
        let explosionTest = Self.checkForExplosion(string)
        var flags = Set<DieFlags>()
        if explosionTest.1 { flags.insert(.explode) }
        let parts = explosionTest.0.split(separator: "d")
        if (1...2).contains(parts.count) == false { throw SwiftDiceErrors.unableToConvertToDie(string) }
        let amount = parts.count == 2 ? try Int(from: parts[0]) : 1
        let sides = parts.count == 2 ? try Int(from: parts[1]) : try Int(from: parts[0])
        self = try Die(amount: amount, sides: sides, flags: flags)
    }
}
private extension Die {
    static func checkForExplosion(_ string: String) -> (String, Bool) {
        if string.contains("!") {
            let newString = string.replacingOccurrences(of: "!", with: "")
            return (newString, true)
        }
        return (string, false)
    }
}

// MARK: - Int Extension
private extension Int {
    init(from part: String.SubSequence) throws {
        guard let int = Int(part) else { throw SwiftDiceErrors.unableToConvertToDie(String(part)) }
        self = int
    }
}

// MARK: - String Extension
public extension String {
    init(_ die: Die) {
        self = "\(die.amount)d\(die.sides)"
    }
}
