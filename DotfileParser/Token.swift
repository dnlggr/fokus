//
//  Token.swift
//  DotfileParser
//
//  Created by Daniel on 11.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

enum Token {
    case bind, plus, fokus_left, fokus_down, fokus_up, fokus_right
    case modifier(String)
    case key(Character)
}

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.bind, .bind), (.plus, .plus), (.fokus_left, .fokus_left), (.fokus_down, .fokus_down),
             (.fokus_up, .fokus_up), (.fokus_right, .fokus_right):
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

