//
//  Dotfile.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public enum DotfileError: Error {
    case couldNotReadDotfile
}

public class Dotfile {
    public static let shared = Dotfile()

    private var filename = ".fokus"

    // MARK: Initialization
    
    private init() { }

    // MARK: API

    public func keyBindings() throws -> [KeyBinding] {
        guard let dotfile = read() else {
            throw DotfileError.couldNotReadDotfile
        }

        return try Parser(source: dotfile).keyBindings()
    }

    // MARK: Private Functions
    
    private func read() -> String? {
        let home = FileManager.default.homeDirectoryForCurrentUser
        
        return try? String(contentsOf: home.appendingPathComponent(filename))
    }
}
