//
//  AppDelegate.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        checkAccessibilityAccess()
    }
    
    func checkAccessibilityAccess() {
        let options = [ kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true ]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
}
