//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public struct Die {
    public let amount: Int
    public let sides: Int
    public init() {
        self.amount = 1
        self.sides = 6
    }
    public init(amount: Int, sides: Int) throws {
        guard amount > 0, sides > 0 else { throw SwiftDiceErrors.valuesCannotBeNegitive(amount, sides) }
        self.amount = amount
        self.sides = sides
    }
}
extension Die: Equatable { }
extension Die: Hashable { }
extension Die: Codable { }
public extension Die {
    init(_ string: String) throws {
        let parts = string.split(separator: "d")
        if parts.count != 2 { throw SwiftDiceErrors.unableToConvertToDie(string) }
        guard let amount = Int(parts[0]), amount > 0 else { throw SwiftDiceErrors.unableToConvertToDie(string) }
        guard let sides = Int(parts[1]), sides > 0 else { throw SwiftDiceErrors.unableToConvertToDie(string) }
        self = try Die(amount: amount, sides: sides)
    }
}

// MARK: - String Extension
public extension String {
    init(_ die: Die) {
        self = "\(die.amount)d\(die.sides)"
    }
}
