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
    public let title: String?
    
    public init(bounds: CGRect, title: String? = nil) {
        self.bounds = bounds
        self.title = title
    }
    
    func dist(to window: Window, on axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            return abs(self.bounds.origin.x - window.bounds.origin.x)
        case .vertical:
            return abs(self.bounds.origin.y - window.bounds.origin.y)
        }
    }
}

extension Window: Equatable {
    public static func ==(lhs: Window, rhs: Window) -> Bool {
        return lhs.bounds == rhs.bounds
    }
}

extension Window {
    func nearest(from windows: [Window], on axis: Axis) -> Window? {
        return windows.sorted(
            by: { $0.dist(to: self, on: axis) < $1.dist(to: self, on: axis) }
        ).first
    }
}
