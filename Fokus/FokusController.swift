//
//  FokusController.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import HotKey
import WindowLayout
import DotfileParser

class FokusController: NSObject {
    
    // MARK: - Properties
    
    var statusMenu = NSMenu()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    var keyBindings: [KeyBinding]?
    
    var hotKeyNorth: HotKey?
    var hotKeyEast: HotKey?
    var hotKeySouth: HotKey?
    var hotKeyWest: HotKey?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        setupIcon()
        readDotfile()
        setupMenu()
        registerHotKeys()
    }
    
    func setupIcon() {
        let icon = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        icon?.isTemplate = true
        
        statusItem.image = icon
    }

    func readDotfile() {
        guard let keyBindings = try? Parser(source: Dotfile.shared.read()).keyBindings() else {
            print("Could not parse dotfile.")
            return
        }

        self.keyBindings = keyBindings
    }
    
    func setupMenu() {
        statusMenu = NSMenu()

        let menuEntries = keyBindings?.map { (binding: KeyBinding) -> (item: NSMenuItem, binding: KeyBinding) in
            switch binding.action {
            case .focus_left:
                return (NSMenuItem(
                    title: binding.action.rawValue,
                    action: #selector(FokusController.moveFocusWest),
                    keyEquivalent: binding.key
                ), binding)
            case .focus_down:
                return (NSMenuItem(
                    title: binding.action.rawValue,
                    action: #selector(FokusController.moveFocusSouth),
                    keyEquivalent: binding.key
                ), binding)
            case .focus_up:
                return (NSMenuItem(
                    title: binding.action.rawValue,
                    action: #selector(FokusController.moveFocusNorth),
                    keyEquivalent: binding.key
                ), binding)
            case .focus_right:
                return (NSMenuItem(
                    title: binding.action.rawValue,
                    action: #selector(FokusController.moveFocusEast),
                    keyEquivalent: binding.key
                ), binding)
            }
        }

        menuEntries?.forEach {
            $0.item.target = self

            var modifiers: NSEvent.ModifierFlags = []
            $0.binding.modifiers.forEach {
                if let modifier = try? $0.modiferFlag() {
                    modifiers.insert(modifier)
                }
            }

            $0.item.keyEquivalentModifierMask = modifiers

            statusMenu.addItem($0.item)
        }

        let reload = NSMenuItem(
            title: "Reload Dotfile",
            action: #selector(FokusController.reloadDotfile),
            keyEquivalent: ""
        )
        reload.target = self

        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(reload)
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem.menu = statusMenu
    }
    
    func registerHotKeys() {
        keyBindings?.forEach {
            var modifiers: NSEvent.ModifierFlags = []
            $0.modifiers.forEach {
                if let modifier = try? $0.modiferFlag() {
                    modifiers.insert(modifier)
                }
            }

            let key = Key(string: $0.key)!

            switch $0.action {
            case .focus_left:
                hotKeyWest = nil
                hotKeyWest = HotKey(key: key, modifiers: modifiers)
                hotKeyWest!.keyDownHandler = { self.moveFocusWest() }
            case .focus_down:
                hotKeySouth = nil
                hotKeySouth = HotKey(key: key, modifiers: modifiers)
                hotKeySouth!.keyDownHandler = { self.moveFocusSouth() }
            case .focus_up:
                hotKeyNorth = nil
                hotKeyNorth = HotKey(key: key, modifiers: modifiers)
                hotKeyNorth!.keyDownHandler = { self.moveFocusNorth() }
            case .focus_right:
                hotKeyEast = nil
                hotKeyEast = HotKey(key: key, modifiers: modifiers)
                hotKeyEast!.keyDownHandler = { self.moveFocusEast() }
            }
        }
    }

    @objc func reloadDotfile() {
        readDotfile()
        setupMenu()
        registerHotKeys()
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

fileprivate extension Modifier {
    enum ModifierError: Error {
        case unsupportedModifier(String)
    }

    func modiferFlag() throws -> NSEvent.ModifierFlags {
        if case .modifier(let value) = self, value == "control" {
            return .control
        }

        if case .modifier(let value) = self, value == "command" {
            return .command
        }

        if case .modifier(let value) = self, value == "shift" {
            return .shift
        }

        if case .modifier(let value) = self, value == "option" {
            return .option
        }

        switch self {
        case .modifier(let value):
            throw ModifierError.unsupportedModifier(value)
        }
    }
}
