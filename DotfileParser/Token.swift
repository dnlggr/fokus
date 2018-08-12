//
//  Token.swift
//  DotfileParser
//
//  Created by Daniel on 11.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public enum Token {
    case bind, plus, focus_left, focus_down, focus_up, focus_right
    case modifier(String)
    case key(String)
}

extension Token: Equatable {
    public static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.bind, .bind), (.plus, .plus), (.focus_left, .focus_left), (.focus_down, .focus_down),
             (.focus_up, .focus_up), (.focus_right, .focus_right):
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
