//
//  Accessibility.swift
//  Focus
//
//  Created by Daniel on 05.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

class Accessibility {
    typealias AccessibilityWindow = AXUIElement
    typealias AccessibilityApplication = AXUIElement
    
    static func application(for pid: Int32) -> AccessibilityApplication {
        return AXUIElementCreateApplication(pid)
    }
}

extension Accessibility.AccessibilityApplication {
    var windows: [Accessibility.AccessibilityWindow] {
        var windows: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXWindowsAttribute as CFString, &windows)
        
        return windows as? Array<Accessibility.AccessibilityWindow> ?? []
    }
}

extension Accessibility.AccessibilityWindow {
    var bounds: CGRect? {
        var positionRef: AnyObject?
        guard AXUIElementCopyAttributeValue(self, kAXPositionAttribute as CFString, &positionRef) == .success else {
            return nil
        }
        
        var sizeRef: AnyObject?
        guard AXUIElementCopyAttributeValue(self, kAXSizeAttribute as CFString, &sizeRef) == .success else {
            return nil
        }
        
        var position = CGPoint.zero
        AXValueGetValue(positionRef as! AXValue, .cgPoint, &position)
        
        var size = CGSize.zero
        AXValueGetValue(sizeRef as! AXValue, .cgSize, &size)
        
        return CGRect(origin: position, size: size)
    }
    
    var title: String? {
        var title: AnyObject?
        guard AXUIElementCopyAttributeValue(self, kAXTitleAttribute as CFString, &title) == .success else {
            return nil
        }
        
        return title as? String
    }
}
