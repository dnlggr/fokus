//
//  Window.swift
//  WindowKit
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public struct Window {
    public let bounds: CGRect
    
    public init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension Window: Equatable {
    public static func ==(lhs: Window, rhs: Window) -> Bool {
        return lhs.bounds == rhs.bounds
    }
}

enum SortingError: Error {
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
                throw SortingError.directionNotSupported
            }
        }
    }
}
