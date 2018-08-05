//
//  Screen.swift
//  WindowKit
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public struct Screen {
    let windows: [Window]
    
    public init(windows: [Window]) {
        self.windows = windows
    }
    
    public func neighbor(of window: Window, toward direction: Direction) -> Window? {
        let neighboringWindows = neighborhood(of: window, toward: direction)
        
//        print("neighbors: START -> ", terminator: "")
//        _ = neighboringWindows.map { print("\($0.title!) -> ", terminator: "") }
//        print("END")
        
        let sortedNeighborhood = try! neighboringWindows.sorted(from: direction.opposite, to: direction)
        
//        print("sorted neighbors: START -> ", terminator: "")
//        _ = sortedNeighborhood.map { print("\($0.title!) -> ", terminator: "") }
//        print("END")
        
        return sortedNeighborhood.first
    }
    
    func neighborhood(of window: Window, toward direction: Direction) -> [Window] {
        return windows.filter {
            $0.bounds.origin.lies(toward: direction, of: window.bounds.origin) &&
            window.bounds.overlap($0.bounds, collapsing: direction.axis)
        }
    }
}

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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
