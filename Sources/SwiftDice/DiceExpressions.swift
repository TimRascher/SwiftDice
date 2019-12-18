//
//  Created by Timothy Rascher on 12/18/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public indirect enum DiceExpressions {
    case die(Die)
    case number(Int)
    case add(DiceExpressions, DiceExpressions)
    case subtract(DiceExpressions, DiceExpressions)
    case multiply(DiceExpressions, DiceExpressions)
    case devide(DiceExpressions, DiceExpressions)
}
public extension DiceExpressions {
    func roll() -> Roll {
        switch self {
        case .die(let die): return die.roll()
        case .number(let value): return DieRoll(value)
        case .add(let lhs, let rhs): return lhs.roll() + rhs.roll()
        case .subtract(let lhs, let rhs): return lhs.roll() - rhs.roll()
        case .multiply(let lhs, let rhs): return lhs.roll() * rhs.roll()
        case .devide(let lhs, let rhs): return lhs.roll() / rhs.roll()
        }
    }
}
public extension DiceExpressions {
    init(_ string: String) throws {
        var parts = try Self.split(string)
        while(parts.count > 1) {
            parts = try Self.combine(parts)
        }
        guard let expression = parts[0].expression else { throw SwiftDiceErrors.invalidSyntax }
        self = expression
    }
}
extension DiceExpressions {
    enum Instructions {
        case add
        case subtract
        case multiply
        case devide
        static func from(_ character: Character) throws -> Instructions {
            switch character {
            case "+": return .add
            case "-": return .subtract
            case "*": return .multiply
            case "/": return .devide
            default: throw SwiftDiceErrors.notAValidInstruction(String(character))
            }
        }
    }
    enum Parts {
        case expression(DiceExpressions)
        case instruction(Instructions)
        var expression: DiceExpressions? {
            switch self {
            case .expression(let expression): return expression
            case .instruction: return nil
            }
        }
    }
    static func split(_ string: String) throws -> [Parts] {
        var instructions = [Parts]()
        var characters = [Character]()
        var collecting = false
        func append() throws {
            var string = String(characters)
            string = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if string != "" {
                if collecting {
                    instructions.append(.expression(try DiceExpressions(string)))
                    collecting = false
                } else if string.contains("d") {
                    instructions.append(.expression(.die(try Die(string))))
                } else if let number = Int(string) {
                    instructions.append(.expression(.number(number)))
                } else {
                    throw SwiftDiceErrors.unableToEvaluateExpression(string)
                }
            }
            characters = [Character]()
        }
        for character in string {
            switch character {
            case "(":
                collecting = true
            case ")":
                try append()
            case "+", "-", "/", "*":
                if collecting == false {
                    try append()
                    instructions.append(.instruction(try .from(character)))
                } else { fallthrough }
            default:
                characters.append(character)
            }
        }
        try append()
        return instructions
    }
    static func combine(_ parts: [Parts]) throws -> [Parts] {
        if parts.has([.add, .subtract]) {
            return try combine(parts, for: [.add, .subtract])
        } else if parts.has([.multiply, .devide]) {
            return try combine(parts, for: [.multiply, .devide])
        } else {
            throw SwiftDiceErrors.noInstructionsFound
        }
    }
    static func combine(_ parts: [Parts], for instructions: [Instructions]) throws -> [Parts] {
        var parts = parts
        var instructionIndex = 0
        var instruction: Instructions?
        loop: for index in 1..<parts.count {
            let part = parts[index]
            switch part {
            case .instruction(let internalInstruction):
                if instructions.contains(internalInstruction) {
                    instructionIndex = index
                    instruction = internalInstruction
                    break loop
                }
            default: continue
            }
        }
        guard
            let unwrappedInstruction = instruction,
            instructionIndex - 1 >= 0,
            instructionIndex + 1 < parts.count else { throw SwiftDiceErrors.invalidSyntax }
        let lhs = parts[instructionIndex - 1]
        let rhs = parts[instructionIndex + 1]
        guard lhs.expression != nil, rhs.expression != nil else { throw SwiftDiceErrors.invalidSyntax }
        parts.remove(at: instructionIndex + 1)
        parts.remove(at: instructionIndex)
        parts.remove(at: instructionIndex - 1)
        func insert(_ expression: DiceExpressions) {
            parts.insert(.expression(expression), at: instructionIndex - 1)
        }
        switch unwrappedInstruction {
        case .add: insert(.add(lhs.expression!, rhs.expression!))
        case .subtract: insert(.subtract(lhs.expression!, rhs.expression!))
        case .multiply: insert(.multiply(lhs.expression!, rhs.expression!))
        case .devide: insert(.devide(lhs.expression!, rhs.expression!))
        }
        return parts
    }
}
private extension Array where Element == DiceExpressions.Parts {
    func has(_ instructions: [DiceExpressions.Instructions]) -> Bool {
        let instructions = self.filter {
            if case let DiceExpressions.Parts.instruction(internalInstruction) = $0 {
                return instructions.contains(internalInstruction)
            }
            return false
        }
        return instructions.count > 0
    }
}
