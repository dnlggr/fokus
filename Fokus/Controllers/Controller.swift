//
//  Controller.swift
//  Fokus
//
//  Created by Daniel on 03.09.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

protocol Controller {
    func load()
    func reload()
}

extension Controller {
    func reload() {
        load()
    }
}
