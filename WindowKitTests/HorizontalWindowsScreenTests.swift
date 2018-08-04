//
//  HorizontalWindowsScreenTests.swift
//  WindowKitTests
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import XCTest
@testable import WindowKit

class HorizontalWindowsScreenTests: XCTestCase {
    
    func testWestEast() {
        let screen = Screen(windows: [
            .first, .second, .third, .fourth
        ])
        
        XCTAssertEqual(screen.neighbor(of: .first, toward: .east), .second)
        XCTAssertEqual(screen.neighbor(of: .second, toward: .east), .third)
        XCTAssertEqual(screen.neighbor(of: .third, toward: .east), .fourth)
        XCTAssertNil(screen.neighbor(of: .fourth, toward: .east))
    }
    
    func testEastWest() {
        let screen = Screen(windows: [
            .first, .second, .third, .fourth
        ])
        
        XCTAssertNil(screen.neighbor(of: .first, toward: .west))
        XCTAssertEqual(screen.neighbor(of: .second, toward: .west), .first)
        XCTAssertEqual(screen.neighbor(of: .third, toward: .west), .second)
        XCTAssertEqual(screen.neighbor(of: .fourth, toward: .west), .third)
    }
    
}

fileprivate extension Screen {
    static var width: Int { return 1024 }
    static var height: Int { return 1024 }
    static var windowCount: Int { return 4 }
}

fileprivate extension Window {
    static var width: Int { return Screen.width / Screen.windowCount }
    static var height: Int { return Screen.height }
    
    static var first: Window { return Window(bounds: CGRect(x: 0 * width, y: 0 * height, width: width, height: height)) }
    static var second: Window { return Window(bounds: CGRect(x: 1 * width, y: 0 * height, width: width, height: height)) }
    static var third: Window { return Window(bounds: CGRect(x: 2 * width, y: 0 * height, width: width, height: height)) }
    static var fourth: Window { return Window(bounds: CGRect(x: 3 * width, y: 0 * height, width: width, height: height)) }
}
