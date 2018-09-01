//
//  MenuController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa

protocol MenuControllerDelegate: class {
    func menuControllerSelectedQuit(_ menuController: MenuController)
    func menuControllerSelectedReloadDotfile(_ menuController: MenuController)
    func menuControllerSelectedFocusLeft(_ menuController: MenuController)
    func menuControllerSelectedFocusDown(_ menuController: MenuController)
    func menuControllerSelectedFocusUp(_ menuController: MenuController)
    func menuControllerSelectedFocusRight(_ menuController: MenuController)
}

class MenuController {
    let statusItem: NSStatusItem

    weak var delegate: MenuControllerDelegate?

    // MARK: Configuration

    lazy var icon: NSImage? = {
        NSImage(named: NSImage.Name("StatusBarButtonImage"))
    }()

    lazy var quit: NSMenuItem = {
        makeItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: "q")
    }()

    lazy var reloadDotfile: NSMenuItem = {
        makeItem(title: "Reload Dotfile", action: #selector(reloadDotfile(_:)), keyEquivalent: "")
    }()

    lazy var focusEntries: [NSMenuItem] = {
        [
            makeItem(title: "Focus Left", action: #selector(focusLeft(_:)), keyEquivalent: ""),
            makeItem(title: "Focus Right", action: #selector(focusRight(_:)), keyEquivalent: ""),
            makeItem(title: "Focus Up", action: #selector(focusUp(_:)), keyEquivalent: ""),
            makeItem(title: "Focus Down", action: #selector(focusDown(_:)), keyEquivalent: "")
        ]
    }()

    // MARK: Initialization

    init(statusItem: NSStatusItem) {
        self.statusItem = statusItem
        statusItem.button?.image = icon

        statusItem.menu = makeMenu()
    }

    // MARK: Private Functions

    func makeMenu() -> NSMenu {
        let menu = NSMenu()

        _ = focusEntries.map(menu.addItem)
        menu.addItem(NSMenuItem.separator())

        menu.addItem(reloadDotfile)
        menu.addItem(NSMenuItem.separator())

        menu.addItem(quit)

        return menu
    }

    func makeItem(title: String, action: Selector? = nil, keyEquivalent: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)

        item.target = self

        return item
    }

    // MARK: Selectors

    @objc func quit(_ sender: Any?) { delegate?.menuControllerSelectedQuit(self) }
    @objc func reloadDotfile(_ sender: Any?) { delegate?.menuControllerSelectedReloadDotfile(self) }
    @objc func focusLeft(_ sender: Any?) { delegate?.menuControllerSelectedFocusLeft(self) }
    @objc func focusDown(_ sender: Any?) { delegate?.menuControllerSelectedFocusDown(self) }
    @objc func focusRight(_ sender: Any?) { delegate?.menuControllerSelectedFocusRight(self) }
    @objc func focusUp(_ sender: Any?) { delegate?.menuControllerSelectedFocusUp(self) }
}
