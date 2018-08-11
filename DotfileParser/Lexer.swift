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

    static var generators: [(pattern: String, token: TokenGenerator)] {
        return [
            ("[ \t\n]*", { _ in nil }),
            ("#.*", { _ in nil }),
            ("bind", { _ in .bind }),
            ("\\+", { _ in .plus }),
            ("fokus_left", { _ in .fokus_left }),
            ("fokus_down", { _ in .fokus_down }),
            ("fokus_up", { _ in .fokus_up }),
            ("fokus_right", { _ in .fokus_right }),
            ("[a-z]{2,}", { lexeme in .modifier(lexeme) }),
            ("[a-zA-Z0-9]", { lexeme in .key(lexeme) })
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

            for (pattern, generator) in Token.generators {
                guard let lexeme = source.match(for: pattern, at: index) else {
                    continue
                }

                matched = true
                index = source.index(index, offsetBy: lexeme.count)

                guard let token = generator(lexeme) else {
                    continue
                }

                return token
            }

            if !matched {
                index = source.index(after: index)
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
