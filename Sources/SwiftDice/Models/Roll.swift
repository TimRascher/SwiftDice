//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public struct Roll {
    public let results: [Result]
    public let total: Int
    public init(_ die: Die) {
        var results = [Result]()
        var total = 0
        for _ in 0..<die.amount {
            let newResult = Int.random(in: 1...die.sides)
            results.append(Result(sides: die.sides, value: newResult))
            total += newResult
        }
        self.results = results
        self.total = total
    }
    public init() {
        self.init(Die())
    }
}
public extension Roll {
    struct Result {
        let sides: Int
        let value: Int
    }
}
public extension Die {
    func roll() -> Roll { Roll(self) }
}
