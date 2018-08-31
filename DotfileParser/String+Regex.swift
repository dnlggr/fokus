//
//  String+Regex.swift
//  DotfileParser
//
//  Created by Daniel on 31.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Foundation

extension String {
    func match(for pattern: String, at index: String.Index) -> String? {
        guard let regex = try? NSRegularExpression(pattern: "^\(pattern)", options: []) else {
            return nil
        }

        let range = regex.rangeOfFirstMatch(in: self, options: [], range: NSRange(index..<endIndex, in: self))

        return range.location != NSNotFound ? (self as NSString).substring(with: range) : nil
    }

    func removingMatches(for patterns: [String]) -> String {
        return patterns.reduce(self) { $0.removingMatch(for: $1) }
    }

    func removingMatch(for pattern: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }

        let range = NSRange(startIndex..<endIndex, in: self)

        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
}
