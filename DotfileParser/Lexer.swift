//
//  Lexer.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

fileprivate extension Token {
    typealias TokenGenerator = (String) -> Token?

    static var patterns: [(pattern: String, token: TokenGenerator)] {
        return [
            ("[ \t\n]*", { _ in nil }),
            ("#.*", { _ in nil }),
            ("bind", { _ in .bind }),
            ("\\+", { _ in .plus }),
            ("focus_left", { _ in .focus_left }),
            ("focus_down", { _ in .focus_down }),
            ("focus_up", { _ in .focus_up }),
            ("focus_right", { _ in .focus_right }),
            ("[a-z]{2,}", { .modifier($0) }),
            ("[a-zA-Z0-9]", { .key($0) })
        ]
    }
}

class Lexer {
    private let source: String
    private var index: String.Index

    init(source: String) {
        self.source = source
        index = source.startIndex
    }

    func token() -> Token? {
        while index != source.endIndex {
            var matched = false

            for (pattern, generator) in Token.patterns {
                guard let lexeme = source.match(for: pattern, at: index) else {
                    continue
                }

                matched = true
                advanceIndex(by: lexeme.count)

                guard let token = generator(lexeme) else {
                    continue
                }

                return token
            }

            if !matched {
                advanceIndex()
            }
        }

        return nil
    }

    func tokens() -> [Token] {
        var tokens: [Token] = []

        while let token = token() {
            tokens.append(token)
        }

        return tokens
    }

    private func advanceIndex(by offset: Int = 1) {
        index = source.index(index, offsetBy: offset)
    }
}

fileprivate extension String {
    func match(for pattern: String, at index: String.Index) -> String? {
        guard let regex = try? NSRegularExpression(pattern: "^\(pattern)", options: []) else {
            return nil
        }

        let range = regex.rangeOfFirstMatch(in: self, options: [], range: NSRange(index..<endIndex, in: self))

        return range.location != NSNotFound ? (self as NSString).substring(with: range) : nil
    }
}
