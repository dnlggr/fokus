//
//  Direction.swift
//  WindowKit
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public enum Direction {
    case north
    case east
    case south
    case west
    
    var opposite: Direction {
        switch self {
        case .north:
            return .south
        case .east:
            return .west
        case .south:
            return .north
        case .west:
            return .east
        }
    }
    
    var axis: Axis {
        switch self {
        case .north:
            return .vertical
        case .east:
            return .horizontal
        case .south:
            return .vertical
        case .west:
            return .horizontal
        }
    }
}
