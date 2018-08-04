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
        let sortedWindows = try! self.windows.sorted(from: direction.opposite, to: direction)
        let windowIndex = sortedWindows.index(of: window)!
        
        return sortedWindows[safe: sortedWindows.index(after: windowIndex)]
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
