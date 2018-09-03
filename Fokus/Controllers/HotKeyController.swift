//
//  HotKeyController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import HotKey
import DotfileParser

protocol HotKeyControllerDelegate: class {
    func hotKeyControllerDidReceiveFocusLeft(_ hotKeyController: HotKeyController)
    func hotKeyControllerDidReceiveFocusDown(_ hotKeyController: HotKeyController)
    func hotKeyControllerDidReceiveFocusUp(_ hotKeyController: HotKeyController)
    func hotKeyControllerDidReceiveFocusRight(_ hotKeyController: HotKeyController)
    func hotKeyControllerDidRegisterHotKeys(for keyBindings: [KeyBinding])
}

class HotKeyController: Controller {
    private var hotKeys: [HotKey]

    weak var delegate: HotKeyControllerDelegate?

    // MARK: Initialization

    init() {
        hotKeys = []
    }

    // MARK: Controller API

    func load() {
        guard let keyBindings = readDotfile() else {
            return
        }

        hotKeys = makeHotKeys(for: keyBindings)

        delegate?.hotKeyControllerDidRegisterHotKeys(for: keyBindings)
    }

    // MARK: Private Functions

    private func readDotfile() -> [KeyBinding]? {
        return try? Dotfile.shared.keyBindings()
    }

    private func makeHotKeys(for keyBindings: [KeyBinding]) -> [HotKey] {
        let hotKeys = keyBindings.map { makeHotKey(for: $0) }

        return hotKeys.compactMap { $0 }
    }

    private func makeHotKey(for keyBinding: KeyBinding) -> HotKey? {
        guard let key = Key(string: keyBinding.key) else {
            return nil
        }

        let keyCombo = KeyCombo(key: key, modifiers: keyBinding.modifiers.modifierFlags)

        return HotKey(keyCombo: keyCombo, keyDownHandler: handler(for: keyBinding.action), keyUpHandler: nil)
    }

    private func handler(for action: Action) -> (() -> ()) {
        switch action {
        case .focus_left:
            return { self.delegate?.hotKeyControllerDidReceiveFocusLeft(self) }
        case .focus_down:
            return { self.delegate?.hotKeyControllerDidReceiveFocusDown(self) }
        case .focus_up:
            return { self.delegate?.hotKeyControllerDidReceiveFocusUp(self) }
        case .focus_right:
            return { self.delegate?.hotKeyControllerDidReceiveFocusRight(self) }
        }
    }
}
