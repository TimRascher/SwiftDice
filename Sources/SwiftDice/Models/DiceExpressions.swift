//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public indirect enum DiceExpressions {
    case die(Die)
    case value(Int)
    case add(DiceExpressions, DiceExpressions)
}
public extension DiceExpressions {
    func roll() {
        
    }
}
