//
//  Geometry.swift
//  WindowLayout
//
//  Created by Daniel on 05.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

extension CGPoint {
    func lies(toward direction: Direction, of other: CGPoint) -> Bool {
        switch direction {
        case .north:
            return self.y < other.y
        case .east:
            return self.x > other.x
        case .south:
            return self.y > other.y
        case .west:
            return self.x < other.x
        }
    }
}

extension CGRect {
    func overlap(_ other: CGRect, collapsing axis: Axis) -> Bool {
        switch axis {
        case .horizontal:
            return self.minY < other.maxY && other.minY < self.maxY
        case .vertical:
            return self.minX < other.maxX && other.minX < self.maxX
        }
    }
}
