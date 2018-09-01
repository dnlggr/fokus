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
    let menuController: MenuController
    let hotKeyController: HotKeyController

    init(statusItem: NSStatusItem) {
        menuController = MenuController(statusItem: statusItem)
        hotKeyController = HotKeyController()

        menuController.delegate = self
        hotKeyController.delegate = self
    }
}

extension AppController: MenuControllerDelegate {
    func menuControllerSelectedQuit(_ menuController: MenuController) {
        print("menu: quit")
    }

    func menuControllerSelectedReloadDotfile(_ menuController: MenuController) {
        print("menu: reload")
    }

    func menuControllerSelectedFocusLeft(_ menuController: MenuController) {
        print("menu: left")
    }

    func menuControllerSelectedFocusDown(_ menuController: MenuController) {
        print("menu: down")
    }

    func menuControllerSelectedFocusUp(_ menuController: MenuController) {
        print("menu: up")
    }

    func menuControllerSelectedFocusRight(_ menuController: MenuController) {
        print("menu: right")
    }
}

extension AppController: HotKeyControllerDelegate {
    func hotKeyControllerDidReceiveFocusLeft(_ hotKeyController: HotKeyController) {
        print("hotkey: left")
    }

    func hotKeyControllerDidReceiveFocusDown(_ hotKeyController: HotKeyController) {
         print("hotkey: down")
    }

    func hotKeyControllerDidReceiveFocusUp(_ hotKeyController: HotKeyController) {
         print("hotkey: up")
    }

    func hotKeyControllerDidReceiveFocusRight(_ hotKeyController: HotKeyController) {
         print("hotkey: right")
    }

    func hotKeyControllerDidRegisterHotKeys(for keyBindings: [KeyBinding]) {
        print("hotkey new: \(keyBindings)")
    }
}
