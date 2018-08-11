//
//  Dotfile.swift
//  DotfileParser
//
//  Created by Daniel on 09.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

public class Dotfile {
    private var filename = ".fokus"
    
    public init() { }
    
    public func read() -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser
        
        guard let dotfile = try? String(contentsOf: home.appendingPathComponent(filename)) else {
            return ""
        }
        
        return dotfile
    }
}
