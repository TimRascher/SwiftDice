//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public enum SwiftDiceErrors: Error, Equatable {
    case unableToConvertToDie(String)
    case valuesCannotBeNegitive(Int, Int)
}
