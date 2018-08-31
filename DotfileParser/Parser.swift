//
//  Parser.swift
//  DotfileParser
//
//  Created by Daniel on 11.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public enum ParserError: Error {
    case unexpectedEOF
    case unexpected(token: Token)
}

public struct KeyBinding {
    public let modifiers: [Modifier]
    public let key: String
    public let action: Action
}

indirect public enum Modifier {
    case modifier(String)
}

public enum Action: String {
    case focus_left = "Focus Left"
    case focus_down = "Focus Down"
    case focus_up = "Focus Up"
    case focus_right = "Focus Right"
}

public class Parser {
    let lexer: Lexer
    var currentToken: Token?

    var tokensLeft: Bool {
        return currentToken != nil
    }

    public init(source: String) {
        lexer = Lexer(source: source)
        advance()
    }

    public func keyBindings() throws -> [KeyBinding] {
        var keyBindings: [KeyBinding] = []

        while tokensLeft {
            keyBindings.append(try parseKeyBinding())
        }

        return keyBindings
    }

    func advance() {
        currentToken = try! lexer.nextToken()
    }

    func consume(_ token: Token) throws {
        guard let currentToken = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard token == currentToken else {
            throw ParserError.unexpected(token: currentToken)
        }

        advance()
    }

    func parseModifier() throws -> Modifier? {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        if case .key = token {
            return nil
        }

        guard case .modifier(let value) = token else {
            throw ParserError.unexpected(token: token)
        }

        advance()

        return .modifier(value.rawValue)
    }

    func parseKey() throws -> String {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard case .key(let key) = token else {
            throw ParserError.unexpected(token: token)
        }

        advance()

        return key
    }

    func parseAction() throws -> Action {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        var action: Action

        switch token {
        case .focus_left:
            action = .focus_left
        case .focus_down:
            action = .focus_down
        case .focus_up:
            action = .focus_up
        case .focus_right:
            action = .focus_right
        default:
            throw ParserError.unexpected(token: token)
        }

        advance()

        return action
    }

    func parseKeyBinding() throws -> KeyBinding {
        try consume(.bind)

        var modifiers: [Modifier] = []
        while let modifier = try parseModifier() {
            modifiers.append(modifier)
            try consume(.plus)
        }

        let key = try parseKey()

        let action = try parseAction()

        return KeyBinding(modifiers: modifiers, key: key, action: action)
    }
}
