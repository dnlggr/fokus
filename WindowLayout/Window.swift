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
}
extension Window: Equatable {
    public static func ==(lhs: Window, rhs: Window) -> Bool {
        return lhs.bounds == rhs.bounds
    }
}
