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
    
    let hotKeyTest = HotKey(key: .t, modifiers: [ .command, .shift ])
    
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
        statusMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem.menu = statusMenu
    }
    
    func registerHotKeys() {
        hotKeyNorth.keyDownHandler = { self.moveFocus(toward: .north) }
        hotKeyEast.keyDownHandler = { self.moveFocus(toward: .east) }
        hotKeySouth.keyDownHandler = { self.moveFocus(toward: .south) }
        hotKeyWest.keyDownHandler = { self.moveFocus(toward: .west) }
        hotKeyTest.keyDownHandler = { self.test() }
    }
    
    func test() {
        let screen = Screen(windows: WindowInfo.all.map { Window(bounds: $0.bounds, title: $0.title) })
        let current = Window(bounds: WindowInfo.current!.bounds, title:  WindowInfo.current!.title)
        let _ = screen.neighbor(of: current, toward: .east)
    }
    
    // MARK: - Focus
    
    func moveFocus(toward direction: Direction) {
        // Get all windows
        let screen = Screen(windows: WindowInfo.all.map { Window(bounds: $0.bounds, title: $0.title) })
        
        // Get current window
        guard let currentWindowInfo = WindowInfo.current else { return }
        let currentWindow = Window(bounds: currentWindowInfo.bounds, title:  currentWindowInfo.title)
        
        // Get neighbor window
        guard let neighborWindow = screen.neighbor(of: currentWindow, toward: direction) else { return }
        
        // Log planned focus transition
        print("\(currentWindow.title ?? "-") -> \(neighborWindow.title ?? "-")")
        
        // Get neighbor window's application process id
        guard let neighborPID = WindowInfo.foremost(with: neighborWindow.bounds)?.ownerPID else { return }
        
        // Get neighbor window's accessibility application
        let neighborAccessibilityApplication = Accessibility.application(for: neighborPID)
        
        // Get neighbor application's windows
        let neighborAccessibilityApplicationWindows = Accessibility.windows(for: neighborAccessibilityApplication)
        
        // Get first accessibility window that
        let neighborAccessibilityWindow = neighborAccessibilityApplicationWindows.first { window in
            return window.bounds == neighborWindow.bounds && window.title == neighborWindow.title
        }
        
        // Activate neighbor appliction
        NSRunningApplication(processIdentifier: neighborPID)?.activate(options: .activateIgnoringOtherApps)
        
        // Bring correct window of neighbor application to front
        AXUIElementPerformAction(neighborAccessibilityWindow!, kAXRaiseAction as CFString)
    }
}
