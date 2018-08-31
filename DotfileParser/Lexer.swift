//
//  Lexer.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

enum LexerError: Error {
    case unexpected(character: Character)
}

class Lexer {
    private let source: String
    private var index: String.Index

    let comment = Token.comment
    let whitespace = Token.whitespace

    // MARK: Initialization

    init(source: String) {
        self.source = source.removingMatches(for: [ comment, whitespace ])

        index = source.startIndex
    }

    // MARK: API

    func tokens() throws -> [Token] {
        var tokens: [Token] = []

        while let token = try nextToken() {
            tokens.append(token)
        }

        return tokens
    }

    func nextToken() throws -> Token? {
        while index != source.endIndex {
            if let token = try token() {
                return token
            }

            advanceIndex()
        }

        return nil
    }

    // MARK: Private Functions
    
    private func token() throws -> Token? {
        for token in Token.patterns {
            if let lexeme = source.match(for: token.pattern, at: index) {
                advanceIndex(by: lexeme.count)
                return token.withLexeme(lexeme)
            }
        }

        if index != source.endIndex {
            throw LexerError.unexpected(character: source[index])
        }

        return nil
    }

    private func advanceIndex(by offset: Int = 1) {
        index = source.index(index, offsetBy: offset)
    }
}
