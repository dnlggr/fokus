//
//  FocusController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import WindowLayout

class FocusController {

    // MARK: Initialization

    init() { }

    // MARK: API

    func focusLeft() {
        moveFocus(toward: .west)
    }

    func focusDown() {
        moveFocus(toward: .south)
    }

    func focusUp() {
        moveFocus(toward: .north)
    }

    func focusRight() {
        moveFocus(toward: .east)
    }

    // MARK: Private Functions

    private func moveFocus(toward direction: Direction) {
        if let neighborWindow = neighborOfCurrentWindow(toward: direction) {
            focus(window: neighborWindow)
        }
    }

    private func neighborOfCurrentWindow(toward direction: Direction) -> Window? {
        // Get all windows
        let screen = Screen(windows: WindowInfo.all.map { Window(bounds: $0.bounds, title: $0.title) })

        // Get current window
        guard let currentWindowInfo = WindowInfo.current else { return nil }
        let currentWindow = Window(bounds: currentWindowInfo.bounds, title:  currentWindowInfo.title)

        // Get neighbor window
        return screen.neighbor(of: currentWindow, toward: direction)
    }

    private func focus(window: Window) {
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
