//
//  AppController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import DotfileParser

class AppController {
    let focusController: FocusController
    let menuController: MenuController
    let hotKeyController: HotKeyController

    init(statusItem: NSStatusItem) {
        focusController = FocusController()
        hotKeyController = HotKeyController()
        menuController = MenuController(statusItem: statusItem)

        hotKeyController.delegate = self
        menuController.delegate = self

        hotKeyController.load()
    }
}

extension AppController: MenuControllerDelegate {
    func menuControllerSelectedQuit(_ menuController: MenuController) {
        NSApplication.shared.terminate(self)
    }

    func menuControllerSelectedReloadDotfile(_ menuController: MenuController) {
        hotKeyController.reload()
    }

    func menuControllerSelectedFocusLeft(_ menuController: MenuController) {
        focusController.focusLeft()
    }

    func menuControllerSelectedFocusDown(_ menuController: MenuController) {
        focusController.focusDown()
    }

    func menuControllerSelectedFocusUp(_ menuController: MenuController) {
        focusController.focusUp()
    }

    func menuControllerSelectedFocusRight(_ menuController: MenuController) {
        focusController.focusRight()
    }
}

extension AppController: HotKeyControllerDelegate {
    func hotKeyControllerDidReceiveFocusLeft(_ hotKeyController: HotKeyController) {
        focusController.focusLeft()
    }

    func hotKeyControllerDidReceiveFocusDown(_ hotKeyController: HotKeyController) {
         focusController.focusDown()
    }

    func hotKeyControllerDidReceiveFocusUp(_ hotKeyController: HotKeyController) {
         focusController.focusUp()
    }

    func hotKeyControllerDidReceiveFocusRight(_ hotKeyController: HotKeyController) {
         focusController.focusRight()
    }

    func hotKeyControllerDidRegisterHotKeys(for keyBindings: [KeyBinding]) {
        menuController.keyBindings = keyBindings
    }
}
