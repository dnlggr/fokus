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
        let screen = Screen(windows: WindowInfo.all!.map { Window(bounds: $0.bounds) })
        
        let currentWindow = Window(bounds: WindowInfo.current!.bounds)
        
        let neighborWindow = screen.neighbor(of: currentWindow, toward: .east)!
        
        NSRunningApplication(
            processIdentifier: WindowInfo.foremost(with: neighborWindow.bounds)!.ownerPID
        )?.activate(options: .activateIgnoringOtherApps)
    }
}
