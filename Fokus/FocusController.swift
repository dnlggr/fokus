//
//  FocusController.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import HotKey
import WindowLayout

class FocusController: NSObject {
    
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
        
        let itemNorth = NSMenuItem(
            title: "Focus up", action: #selector(FocusController.moveFocusNorth), keyEquivalent: "k"
        )
        let itemEast = NSMenuItem(
            title: "Focus right", action: #selector(FocusController.moveFocusEast), keyEquivalent: "l"
        )
        let itemSouth = NSMenuItem(
            title: "Focus down", action: #selector(FocusController.moveFocusSouth), keyEquivalent: "j"
        )
        let itemWest = NSMenuItem(
            title: "Focus left", action: #selector(FocusController.moveFocusWest), keyEquivalent: "h"
        )
        
        _ = [ itemNorth, itemEast, itemSouth, itemWest ].map {
            $0.target = self
            $0.keyEquivalentModifierMask = .option
            
            statusMenu.addItem($0)
        }
        
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem.menu = statusMenu
    }
    
    func registerHotKeys() {
        hotKeyNorth.keyDownHandler = { self.moveFocus(toward: .north) }
        hotKeyEast.keyDownHandler = { self.moveFocus(toward: .east) }
        hotKeySouth.keyDownHandler = { self.moveFocus(toward: .south) }
        hotKeyWest.keyDownHandler = { self.moveFocus(toward: .west) }
    }
    
    // MARK: - Selectors
    
    @objc func moveFocusNorth() { moveFocus(toward: .north) }
    @objc func moveFocusEast() { moveFocus(toward: .east) }
    @objc func moveFocusSouth() { moveFocus(toward: .south) }
    @objc func moveFocusWest() { moveFocus(toward: .west) }
    
    // MARK: - Focus
    
    func moveFocus(toward direction: Direction) {
        if let neighborWindow = neighborOfCurrentWindow(toward: direction) {
            focus(window: neighborWindow)
        }
    }
    
    func neighborOfCurrentWindow(toward direction: Direction) -> Window? {
        // Get all windows
        let screen = Screen(windows: WindowInfo.all.map { Window(bounds: $0.bounds, title: $0.title) })
        
        // Get current window
        guard let currentWindowInfo = WindowInfo.current else { return nil }
        let currentWindow = Window(bounds: currentWindowInfo.bounds, title:  currentWindowInfo.title)
        
        // Get neighbor window
        return screen.neighbor(of: currentWindow, toward: direction)
    }
    
    func focus(window: Window) {
        // Get window's accessibility application
        guard let pid = WindowInfo.foremost(with: window.bounds)?.ownerPID else { return }
        let accessibilityApplication = Accessibility.application(for: pid)
        
        // Get first accessibility window with same bounds and title as window as there seems
        // to be no other way of matching windows with CGWindowInfo to Accessibility windows
        let accessibilityWindow = accessibilityApplication.windows.first {
            return $0.bounds == window.bounds && $0.title == window.title
        }
        
        if let accessibilityWindow = accessibilityWindow {
            // Activate appliction
            NSRunningApplication(processIdentifier: pid)?.activate(options: .activateIgnoringOtherApps)
            
            // Raise correct window of application
            AXUIElementPerformAction(accessibilityWindow, kAXRaiseAction as CFString)
        }
    }
    
}