//
//  Lexer.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

fileprivate extension Token {
    typealias TokenGenerator = (String) -> Token

    static var patterns: [(pattern: String, token: TokenGenerator)] {
        return [
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
        self.source = source.removingMatches(for: [ "#.*", "[ \t\n]*" ])
        index = source.startIndex
    }

    func token() -> Token? {
        while index != source.endIndex {
            for (pattern, generator) in Token.patterns {
                guard let lexeme = source.match(for: pattern, at: index) else {
                    continue
                }

                advanceIndex(by: lexeme.count)

                return generator(lexeme)
            }

            advanceIndex()
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

    func removingMatch(for pattern: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }

        let range = NSRange(startIndex..<endIndex, in: self)

        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }

    func removingMatches(for patterns: [String]) -> String {
        return patterns.reduce(self) { $0.removingMatch(for: $1) }
    }
}
