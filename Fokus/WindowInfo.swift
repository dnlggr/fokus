//
//  WindowInfo.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

struct WindowInfo {
    let info: [CFString: AnyObject]
    
    var bounds: CGRect {
        return CGRect(dictionaryRepresentation: info[kCGWindowBounds] as! CFDictionary)!
    }
    
    var title: String {
        return info[kCGWindowName] as! String
    }
    
    var ownerPID: Int32 {
        return info[kCGWindowOwnerPID] as! Int32
    }
}

extension WindowInfo {
    static var all: [WindowInfo] {
        var windowInfos = CGWindowListCopyWindowInfo(
            [ .optionOnScreenOnly, .excludeDesktopElements ], kCGNullWindowID
        ) as! [[CFString: AnyObject]]
        
        windowInfos = windowInfos.filter { $0[kCGWindowLayer] as! Int32 == 0 }
        
        return windowInfos.map { WindowInfo(info: $0) }
    }
    
    static var current: WindowInfo? {
        return all.first
    }
    
    static func foremost(with bounds: CGRect) -> WindowInfo?  {
        return WindowInfo.all.first { $0.bounds == bounds }
    }
}
