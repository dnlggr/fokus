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

public class Parser {
    private var tokens: [Token]

    private var currentToken: Token? {
        return tokens.first
    }

    // MARK: Initialization

    public init(source: String) throws {
        tokens = try Lexer(source: source).tokens()
    }

    // MARK: API

    public func keyBindings() throws -> [KeyBinding] {
        var keyBindings: [KeyBinding] = []

        while !tokens.isEmpty {
            keyBindings.append(try parseKeyBinding())
        }

        return keyBindings
    }

    // MARK: Parsing

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

        switch value {
        case .command:
            return .command
        case .control:
            return .control
        case .option:
            return .option
        case .shift:
            return .shift
        }
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

    // MARK: Private Functions

    private func advance() {
        tokens = Array(tokens.dropFirst())
    }

    private func consume(_ token: Token) throws {
        guard let currentToken = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard token == currentToken else {
            throw ParserError.unexpected(token: currentToken)
        }

        advance()
    }
}
