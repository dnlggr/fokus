//
//  Sorting.swift
//  WindowLayout
//
//  Created by Daniel on 05.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

enum WindowSortingError: Error {
    case directionNotSupported
}

extension Array where Element == Window {
    func sorted(from: Direction, to: Direction) throws -> [Window] {
        return try self.sorted { (lhs, rhs) in
            switch (from, to) {
            case (.north, .south):
                return lhs.bounds.origin.y < rhs.bounds.origin.y
            case  (.south, .north):
                return lhs.bounds.origin.y > rhs.bounds.origin.y
            case (.west, .east):
                return lhs.bounds.origin.x < rhs.bounds.origin.x
            case (.east, .west):
                return lhs.bounds.origin.x > rhs.bounds.origin.x
            default:
                throw WindowSortingError.directionNotSupported
            }
        }
    }
}
