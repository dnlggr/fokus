//
//  MenuViewController.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import HotKey
import WindowLayout

class MenuController: NSObject {
    
    // MARK: - Properties
    
    var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    let hotKeyNorth = HotKey(key: .k, modifiers: .option)
    let hotKeyEast = HotKey(key: .l, modifiers: .option)
    let hotKeySouth = HotKey(key: .j, modifiers: .option)
    let hotKeyWest = HotKey(key: .h, modifiers: .option)
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        setupIcon()
        setupMenu()
        
        registerHotKeys()
    }
    
    func setupIcon() {
        let icon = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        icon?.isTemplate = true
        statusItem.image = icon
    }
    
    func setupMenu() {
        statusMenu = NSMenu()
        statusMenu.addItem(
            NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        )
        statusItem.menu = statusMenu
    }
    
    func registerHotKeys() {
        hotKeyNorth.keyDownHandler = { self.moveFocus(toward: .north) }
        hotKeyEast.keyDownHandler = { self.moveFocus(toward: .east) }
        hotKeySouth.keyDownHandler = { self.moveFocus(toward: .south) }
        hotKeyWest.keyDownHandler = { self.moveFocus(toward: .west) }
    }
    
    // MARK: - Focus
    
    func moveFocus(toward direction: Direction) {
        let screen = Screen(windows: WindowInfo.all!.map { Window(bounds: $0.bounds, title: $0.title) })
        
        let currentWindow = Window(bounds: WindowInfo.current!.bounds, title:  WindowInfo.current!.title)
        
        let neighborWindow = screen.neighbor(of: currentWindow, toward: direction)!
        
        let neighborPID = WindowInfo.foremost(with: neighborWindow.bounds)!.ownerPID
        
        let app = AXUIElementCreateApplication(neighborPID)
        var windowsRef: AnyObject?
        AXUIElementCopyAttributeValue(app, kAXWindowsAttribute as CFString, &windowsRef)
        let windows = windowsRef as! Array<AXUIElement>
        
        let window = windows.first { window in
            var positionRef: AnyObject?
            AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &positionRef)
            var sizeRef: AnyObject?
            AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeRef)
            var titleRef: AnyObject?
            AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            
            var origin = CGPoint.zero
            AXValueGetValue(positionRef as! AXValue, .cgPoint, &origin)
        
            var size = CGSize.zero
            AXValueGetValue(sizeRef as! AXValue, .cgSize, &size)
            
            let bounds = CGRect(origin: origin, size: size)
            
            let title = titleRef as? String
            
            return bounds == neighborWindow.bounds && title == neighborWindow.title
        }
        
        NSRunningApplication(processIdentifier: neighborPID)?.activate(options: .activateIgnoringOtherApps)
        AXUIElementPerformAction(window!, kAXRaiseAction as CFString)
    }
}
