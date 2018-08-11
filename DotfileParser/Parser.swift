//
//  Parser.swift
//  DotfileParser
//
//  Created by Daniel on 11.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case unexpectedEOF
    case unexpected(token: Token)
    case unexpectedToken(seen: Token, expected: Token)
}

struct KeyBinding {
    let modifier: String
    let key: Character
    let action: String
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

    func advance() {
        currentToken = lexer.token()
    }

    func consume(_ token: Token) throws {
        guard let currentToken = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard token == currentToken else {
            throw ParserError.unexpectedToken(seen: currentToken, expected: token)
        }

        advance()
    }

    func parseModifier() throws -> String {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard case .modifier(let modifier) = token else {
            throw ParserError.unexpectedToken(seen: token, expected: .modifier(""))
        }

        advance()

        return modifier
    }

    func parseKey() throws -> Character {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        guard case .key(let key) = token else {
            throw ParserError.unexpectedToken(seen: token, expected: .key(Character("")))
        }

        advance()

        return key
    }

    func parseAction() throws -> String {
        guard let token = currentToken else {
            throw ParserError.unexpectedEOF
        }

        var action = ""

        switch token {
        case .fokus_left:
            action = "fokus_left"
        case .fokus_down:
            action = "fokus_down"
        case .fokus_up:
            action = "fokus_up"
        case .fokus_right:
            action = "fokus_right"
        default:
            throw ParserError.unexpected(token: token)
        }

        advance()

        return action
    }

    func parseKeyBinding() throws -> KeyBinding {
        try consume(.bind)
        let modifier = try parseModifier()
        try consume(.plus)
        let key = try parseKey()
        let action = try parseAction()

        return KeyBinding(modifier: modifier, key: key, action: action)
    }

    public func test() {
        var keyBindings: [KeyBinding] = []

        while tokensLeft {
            keyBindings.append(try! parseKeyBinding())
        }

        print(keyBindings)
    }
}
