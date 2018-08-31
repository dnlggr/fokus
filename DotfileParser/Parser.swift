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

        return KeyBinding(
            modifiers: try parseModifiers(),
            key: try parseKey(),
            action: try parseAction()
        )
    }

    func parseModifiers() throws -> [Modifier] {
        var modifiers: [Modifier] = []

        while let modifier = try parseModifier() {
            modifiers.append(modifier)
            try consume(.plus)
        }

        return modifiers
    }

    func parseModifier() throws -> Modifier? {
        if case .some(.key) = peekToken() {
            return nil
        }

        let token = try popToken()

        guard case .modifier(let value) = token else {
            throw ParserError.unexpected(token: token)
        }

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
        let token = try popToken()

        guard case .key(let key) = token else {
            throw ParserError.unexpected(token: token)
        }

        return key
    }

    func parseAction() throws -> Action {
        let token = try popToken()

        switch token {
        case .focus_left:
            return .focus_left
        case .focus_down:
            return .focus_down
        case .focus_up:
            return .focus_up
        case .focus_right:
            return .focus_right
        default:
            throw ParserError.unexpected(token: token)
        }
    }

    // MARK: Private Functions

    private func peekToken() -> Token? {
        return tokens.first
    }

    private func popToken() throws -> Token {
        guard let token = tokens.first else {
            throw ParserError.unexpectedEOF
        }

        tokens = Array(tokens.dropFirst())

        return token
    }

    private func consume(_ token: Token) throws {
        let seenToken = try popToken()

        guard token == seenToken else {
            throw ParserError.unexpected(token: seenToken)
        }
    }
}
