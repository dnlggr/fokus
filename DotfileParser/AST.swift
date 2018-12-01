//
//  AST.swift
//  DotfileParser
//
//  Created by Daniel on 31.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public struct KeyBinding {
    public let modifiers: [Modifier]
    public let key: String
    public let action: Action
}

public enum Modifier {
    case command
    case control
    case option
    case shift
}

public enum Action {
    case focus_left
    case focus_down
    case focus_up
    case focus_right
}
