//
//  Token.swift
//  DotfileParser
//
//  Created by Daniel on 11.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

enum ModifierToken: String, CaseIterable {
    case command
    case control
    case option
    case shift
}

enum Token {
    case bind
    case plus
    case focus_left
    case focus_down
    case focus_up
    case focus_right
    case modifier(ModifierToken)
    case key(String)

    static var comment: String {
        return "#.*"
    }

    static var whitespace: String {
        return "[ \t\n]*"
    }

    static var patterns: [ (pattern: String, withLexeme: (String) -> Token) ] {
        return [
            (
                pattern: "bind",
                withLexeme: { _ in .bind }
            ),
            (
                pattern: "\\+",
                withLexeme: { _ in .plus }
            ),
            (
                pattern: "focus_left",
                withLexeme: { _ in .focus_left }
            ),
            (
                pattern: "focus_down",
                withLexeme: { _ in .focus_down }
            ),
            (
                pattern: "focus_up",
                withLexeme: { _ in .focus_up }
            ),
            (
                pattern: "focus_right",
                withLexeme: { _ in .focus_right }),
            (
                pattern:"(\(ModifierToken.allCases.map({ $0.rawValue }).joined(separator: "|")))",
                withLexeme: { .modifier(ModifierToken(rawValue: $0)!) }
            ),
            (
                pattern: "[a-zA-Z0-9]{1}",
                withLexeme: { .key($0) }
            )
        ]
    }
}

extension Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .bind:
            return "bind"
        case .plus:
            return "+"
        case .focus_up:
            return "focus_up"
        case .focus_down:
            return "focus_down"
        case .focus_left:
            return "focus_left"
        case .focus_right:
            return "focus_right"
        case .key(let value):
            return value
        case .modifier(let value):
            return value.rawValue
        }
    }
}

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.bind, .bind),
             (.plus, .plus),
             (.focus_left, .focus_left),
             (.focus_down, .focus_down),
             (.focus_up, .focus_up),
             (.focus_right, .focus_right):
            return true
        case (.modifier(let lhs), .modifier(let rhs)):
            return lhs == rhs
        case (.key(let lhs), .key(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
