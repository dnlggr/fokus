//
//  Screen.swift
//  WindowKit
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

public struct Screen {
    let windows: [Window]
    
    public init(windows: [Window]) {
        self.windows = windows
    }


    /// For the specified window, finds the neighboring window, if any, from the windows on the screen.
    /// The search for a neighbor will only be directed toward the specified direction.
    /// If several windows are in the neighborhood of the specified window, the nearest window will be returned.
    ///
    /// - Parameters:
    ///   - window: The window whose neighbor to find.
    ///   - direction: The direction in which to search for a neighbor.
    /// - Returns: The neighboring window or `nil` if no window could be found in the specified direction.
    public func neighbor(of window: Window, toward direction: Direction) -> Window? {
        return window.nearest(from: neighborhood(of: window, toward: direction), on: direction.axis.opposite)
    }
    
    private func neighborhood(of window: Window, toward direction: Direction) -> [Window] {
        return windows.filter {
            let liesTowardDirection = $0.bounds.origin.lies(toward: direction, of: window.bounds.origin)
            let isInLine = window.bounds.overlaps(with: $0.bounds, collapsing: direction.axis)

            return liesTowardDirection && isInLine
        }
    }
}
