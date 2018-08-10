//
//  Lexer.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

class Lexer {
    typealias TokenGenerator = (String) -> Token?
    
    enum Token: String {
        case set = "set"
        case bind = "bind"
        case modifier = "mod"
        case plus = "+"
        case modifierKey = "[a-z]"
    }
    
    let tokens: [(String, TokenGenerator)] = [
        ("[ \t\n]", { _ in nil }),
        ("#.*", { _ in nil }),
        (Token.set.rawValue, { _ in .set }),
        (Token.bind.rawValue, { _ in .bind }),
        (Token.modifier.rawValue, { _ in .modifier }),
        (Token.plus.rawValue, { _ in .plus }),
        (Token.modifierKey.rawValue, {_ in .modifierKey })
    ]
    
    func tokenize(_ dotfile: String) -> [Token] {
        var foundTokens: [Token] = []
        var input = dotfile
        
        while input.count > 0 {
            var didMatch = false
            
            for (pattern, generateToken) in tokens {
                if let match = input.match(pattern) {
                    if let token = generateToken(match) {
                        foundTokens.append(token)
                    }
                    
                    input = String(input[input.index(input.startIndex, offsetBy: match.count)...])
                    didMatch = true
                    break
                }
            }
            
            if !didMatch {
                input = String(input[input.index(after: input.startIndex)...])
            }
        }
        
        return foundTokens
    }
}

extension String {
    public func match(_ regex: String) -> String? {
        let expression = try! NSRegularExpression(pattern: "^\(regex)", options: [])
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.utf8.count))
        if range.location != NSNotFound {
            return (self as NSString).substring(with: range)
        }
        
        return nil
    }
}
