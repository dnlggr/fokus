//
//  Axis.swift
//  WindowLayout
//
//  Created by Daniel on 05.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

enum Axis {
    case horizontal
    case vertical
    
    var opposite: Axis {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        }
    }
}
