//
//  Modifer+ModifierFlags.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import DotfileParser

extension Modifier {
    var modifierFlag: NSEvent.ModifierFlags {
        switch self {
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
}

extension Array where Element == Modifier {
    var modifierFlags: NSEvent.ModifierFlags {
        var modifiers: NSEvent.ModifierFlags = []
        self.forEach { modifiers.insert($0.modifierFlag) }

        return modifiers
    }
}
