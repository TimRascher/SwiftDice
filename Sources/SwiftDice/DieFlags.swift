//
//  Created by Timothy Rascher on 12/19/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public enum DieFlags {
    case explode
    case keep(Int)
    case fate
}
private extension DieFlags {
    enum CodingKeys: CodingKey {
        case explode
        case keep
        case fate
    }
}
extension DieFlags: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.count != 1 { throw SwiftDiceErrors.wrongNumberOfFlags(container.allKeys.count) }
        switch container.allKeys[0] {
        case .explode: self = .explode
        case .keep: self = .keep(try container.decode(Int.self, forKey: .keep))
        case .fate: self = .fate
        }
    }
}
extension DieFlags: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .explode: try container.encode(true, forKey: .explode)
        case .keep(let value): try container.encode(value, forKey: .keep)
        case .fate: try container.encode(true, forKey: .fate)
        }
    }
}
extension DieFlags: Hashable {}
