//
//  ParserTests.swift
//  DotfileParserTests
//
//  Created by Daniel on 31.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import XCTest
@testable import DotfileParser

class ParserTests: XCTestCase {

    var dotfile: String = ""

    override func setUp() {
        dotfile = try! String(contentsOf: Bundle(for: type(of: self)).url(forResource: "dotfile", withExtension: nil)!)
    }

    func testParsingCorrectDotfile() {
        let keyBindings = try! Parser(source: dotfile).keyBindings()

        XCTAssertEqual(keyBindings, [
            KeyBinding(modifiers: [ .command, .control ], key: "h", action: .focus_left),
            KeyBinding(modifiers: [ .command, .control ], key: "j", action: .focus_down),
            KeyBinding(modifiers: [ .command, .control ], key: "k", action: .focus_up),
            KeyBinding(modifiers: [ .command, .control ], key: "l", action: .focus_right)
        ])
    }

    func testParsingMissingBind() {
        dotfile = dotfile.replacingOccurrences(of: "bind", with: "")

        XCTAssertThrowsError(try Parser(source: dotfile).keyBindings()) {
            XCTAssertEqual($0 as! ParserError, ParserError.unexpected(token: "command"))
        }
    }

    func testParsingMissingModifier() {
        dotfile = dotfile.replacingOccurrences(of: "command", with: "")
        dotfile = dotfile.replacingOccurrences(of: "control", with: "")

        XCTAssertThrowsError(try Parser(source: dotfile).keyBindings()) {
            XCTAssertEqual($0 as! ParserError, ParserError.unexpected(token: "+"))
        }
    }

    func testParsingMissingPlus() {
//        dotfile = dotfile.replacingOccurrences(of: "+", with: "")
//
//        XCTAssertThrowsError(try Parser(source: dotfile).keyBindings()) {
//            XCTAssertEqual($0 as! ParserError, ParserError.unexpected(token: .plus))
//        }
    }
}

extension KeyBinding: Equatable {
    public static func ==(lhs: KeyBinding, rhs: KeyBinding) -> Bool {
        return
            lhs.action == rhs.action &&
            lhs.key == rhs.key &&
            lhs.modifiers == rhs.modifiers
    }
}

extension ParserError: Equatable {
    public static func ==(lhs: ParserError, rhs: ParserError) -> Bool {
        switch (lhs, rhs) {
        case (.unexpectedEOF, .unexpectedEOF):
            return true
        case (.unexpected(let lhs), .unexpected(let rhs)):
            return lhs == rhs
        case (.unexpectedEOF, _),
             (.unexpected(_), _):
            return false
        }
    }
}
