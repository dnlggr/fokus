//
//  AppDelegate.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var appController: AppController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        checkAccessibilityAccess()
        
        appController = AppController(statusItem: statusItem)
    }

    func checkAccessibilityAccess() {
        let options = [ kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true ]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
}
