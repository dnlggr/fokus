//
//  ViewController.swift
//  Focus
//
//  Created by Daniel on 04.08.18.
//  Copyright © 2018 Daniel Egger. All rights reserved.
//

import Cocoa
import WindowKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var windowInfos = CGWindowListCopyWindowInfo(
            [ .optionOnScreenOnly, .excludeDesktopElements ], kCGNullWindowID
        ) as! [[CFString: AnyObject]]
        
        windowInfos = windowInfos.filter {
            return CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!.height > 22
        }
        
        let windows = windowInfos.map {
            return Window(bounds: CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!)
        }
        
        let numiInfo = windowInfos.first(where: {
            return "Numi" == $0[kCGWindowOwnerName] as! CFString as String
        })!
        
        let numi = Window(bounds: CGRect(dictionaryRepresentation: numiInfo[kCGWindowBounds] as! CFDictionary)!)
        
        let screen = Screen(windows: windows)
        
        let neighbor = screen.neighbor(of: numi, toward: .east)!
        
        let neighborInfo = windowInfos.first(where: {
            Window(bounds: CGRect(dictionaryRepresentation: $0[kCGWindowBounds] as! CFDictionary)!) == neighbor
        })!
        
        let neighborApp = NSRunningApplication(processIdentifier: neighborInfo[kCGWindowOwnerPID] as! Int32)
        
        neighborApp!.activate(options: .activateIgnoringOtherApps)
    }
    
    func filtered(_ windows: [[CFString: AnyObject]]) -> [[CFString: AnyObject]] {
       return windows.filter { window in
            let bounds = CGRect(dictionaryRepresentation: window[kCGWindowBounds] as! CFDictionary)!
            return bounds.height > 22
        }
    }
    
}
