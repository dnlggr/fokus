//
//  DotfileParserTests.swift
//  DotfileParserTests
//
//  Created by Daniel on 31.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import XCTest
@testable import DotfileParser

class LexerTests: XCTestCase {
    
    var dotfile: String = ""

    override func setUp() {
        dotfile = try! String(contentsOf: Bundle(for: type(of: self)).url(forResource: "dotfile", withExtension: nil)!)
    }

    func testScanningCorrectDotfile() {
        let tokens = try! Lexer(source: dotfile).tokens()

        XCTAssertEqual(tokens, [
            .bind, .modifier(.command), .plus, .modifier(.control), .plus, .key("h"), .focus_left,
            .bind, .modifier(.command), .plus, .modifier(.control), .plus, .key("j"), .focus_down,
            .bind, .modifier(.command), .plus, .modifier(.control), .plus, .key("k"), .focus_up,
            .bind, .modifier(.command), .plus, .modifier(.control), .plus, .key("l"), .focus_right
        ])
    }

    func testLexerDetectsInvalidCharacterAtStartOfDotfile() {
        dotfile = "/" + dotfile

        XCTAssertThrowsError(try Lexer(source: dotfile).tokens()) {
            XCTAssertEqual($0 as! LexerError, LexerError.unexpected(character: Character("/")))
        }
    }

    func testLexerDetectsInvalidCharacterAtEndOfDotfile() {
        dotfile = dotfile + "$"

        XCTAssertThrowsError(try Lexer(source: dotfile).tokens()) {
            XCTAssertEqual($0 as! LexerError, LexerError.unexpected(character: Character("$")))
        }
    }

    func testLexerDetectsInvalidCharacterInDotfile() {
        dotfile =
            dotfile[dotfile.startIndex..<dotfile.index(dotfile.startIndex, offsetBy: dotfile.count - 10)] +
            "%" +
            dotfile[dotfile.index(dotfile.startIndex, offsetBy: dotfile.count - 10)..<dotfile.endIndex]

        XCTAssertThrowsError(try Lexer(source: dotfile).tokens()) {
            XCTAssertEqual($0 as! LexerError, LexerError.unexpected(character: Character("%")))
        }
    }
}

extension LexerError: Equatable {
    public static func ==(lhs: LexerError, rhs: LexerError) -> Bool {
        switch (lhs, rhs) {
        case (.unexpected(let lhs), .unexpected(let rhs)):
            return lhs == rhs
        }
    }
}
