//
//  MenuViewController.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import WindowLayout
import HotKey

class MenuController: NSObject {
    
    var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let hotKey = HotKey(key: .l, modifiers: .option)
    
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
        let testItem = NSMenuItem(title: "Test", action: #selector(testClicked(_:)), keyEquivalent: "l")
        testItem.keyEquivalentModifierMask = .option
        testItem.target = self
        statusMenu.addItem(testItem)
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = statusMenu
    }
    
    func registerHotKeys() {
        hotKey.keyDownHandler = doTest
    }
    
    @objc func testClicked(_ sender: Any?) {
        doTest()
    }
    
    func doTest() {
        var windowInfos = CGWindowListCopyWindowInfo(
            [ .optionOnScreenOnly, .excludeDesktopElements ], kCGNullWindowID
            ) as! [[CFString: AnyObject]]
        
        windowInfos = windowInfos.filter {
            return CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!.height > 22
        }
        
        let windows = windowInfos.map {
            return Window(bounds: CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!)
        }
        
        let numiInfo = windowInfos.first(where: {
            return "Numi" == $0[kCGWindowOwnerName] as! CFString as String
        })!
        
        let numi = Window(bounds: CGRect(dictionaryRepresentation: numiInfo[kCGWindowBounds] as! CFDictionary)!)
        
        let screen = Screen(windows: windows)
        
        let neighbor = screen.neighbor(of: numi, toward: .east)!
        
        let neighborInfo = windowInfos.first(where: {
            Window(bounds: CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!) == neighbor
        })!
        
        let neighborApp = NSRunningApplication(processIdentifier: neighborInfo[kCGWindowOwnerPID] as! Int32)
        
        neighborApp!.activate(options: .activateIgnoringOtherApps)
    }
}
