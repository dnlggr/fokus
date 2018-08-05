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
        let sortedNeighborhood = try! neighboringWindows.sorted(from: direction.opposite, to: direction)
        
        return sortedNeighborhood.first
    }
    
    private func neighborhood(of window: Window, toward direction: Direction) -> [Window] {
        return windows.filter {
            $0.bounds.origin.lies(toward: direction, of: window.bounds.origin) &&
            window.bounds.overlap($0.bounds, collapsing: direction.axis)
        }
    }
}
