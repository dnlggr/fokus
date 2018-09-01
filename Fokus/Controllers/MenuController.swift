//
//  MenuController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import DotfileParser

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

    var keyBindings: [KeyBinding] = [] {
        didSet { reload() }
    }

    // MARK: Initialization

    init(statusItem: NSStatusItem) {
        self.statusItem = statusItem
    }

    // MARK: API

    func load() {
        reload()
    }

    func reload() {
        statusItem.button?.image = icon
        statusItem.menu = makeMenu()
    }

    // MARK: Private Functions

    private func makeMenu() -> NSMenu {
        let menu = NSMenu()

        makeFocusItems().forEach { menu.addItem($0) }
        menu.addItem(NSMenuItem.separator())

        menu.addItem(makeReloadItem())
        menu.addItem(NSMenuItem.separator())

        menu.addItem(makeQuitItem())

        return menu
    }

    private func makeQuitItem() -> NSMenuItem {
        return makeItem(title: "Quit", selector: #selector(quit(_:)), key: "q", modifiers: .command)
    }

    private func makeReloadItem() -> NSMenuItem {
        return makeItem(title: "Reload Dotfile", selector: #selector(reloadDotfile(_:)))
    }

    private func makeFocusItems() -> [NSMenuItem] {
        return [
            makeFocusItem("Focus Left", for: .focus_left, selector: #selector(focusLeft(_:))),
            makeFocusItem("Focus Down", for: .focus_down, selector: #selector(focusDown(_:))),
            makeFocusItem("Focus Up", for: .focus_up, selector: #selector(focusUp(_:))),
            makeFocusItem("Focus Right", for: .focus_right, selector: #selector(focusRight(_:)))
        ]
    }

    private func makeFocusItem(_ title: String, for action: Action, selector: Selector) -> NSMenuItem {
        var modifierFlags: NSEvent.ModifierFlags = []
        var key = ""

        if let keyBinding = keyBindings.first(where: { $0.action == action }) {
            modifierFlags = keyBinding.modifiers.modifierFlags
            key = keyBinding.key
        }

        return makeItem(title: title, selector: selector, key: key, modifiers: modifierFlags)
    }

    private func makeItem(
        title: String,
        selector: Selector,
        key: String = "",
        modifiers: NSEvent.ModifierFlags? = nil
    ) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: key)

        item.target = self
        item.keyEquivalentModifierMask = modifiers ?? []

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
