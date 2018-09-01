//
//  AppController.swift
//  Fokus
//
//  Created by Daniel on 01.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa

class AppController {
    let menuController: MenuController

    init(statusItem: NSStatusItem) {
        menuController = MenuController(statusItem: statusItem)
    }
}
