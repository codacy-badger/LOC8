//
//  AppDelegate.swift
//  LOC8 App
//
//  Created by Marwan Al Masri on 3/26/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        MultipeerManager.shared.isBrowsing = true
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

