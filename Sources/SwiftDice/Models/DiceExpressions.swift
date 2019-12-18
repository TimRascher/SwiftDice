//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public indirect enum DiceExpressions {
    case die(Die)
    case value(Int)
    case add(DiceExpressions, DiceExpressions)
    case subtract(DiceExpressions, DiceExpressions)
    case multiply(DiceExpressions, DiceExpressions)
    case devide(DiceExpressions, DiceExpressions)
}
public extension DiceExpressions {
    func roll() -> Roll {
        switch self {
        case .die(let die): return die.roll()
        case .value(let value): return DieRoll(value)
        case .add(let lhs, let rhs): return lhs.roll() + rhs.roll()
        case .subtract(let lhs, let rhs): return lhs.roll() - rhs.roll()
        case .multiply(let lhs, let rhs): return lhs.roll() * rhs.roll()
        case .devide(let lhs, let rhs): return lhs.roll() / rhs.roll()
        }
    }
}
