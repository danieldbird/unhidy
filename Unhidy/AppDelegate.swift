//
//  AppDelegate.swift
//  Unhidy
//
//  Created by Daniel Bird on 3/07/17.
//  Copyright © 2017 Daniel Bird. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let filePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0].appending("/Preferences/com.apple.finder.plist")
        let myDict: NSDictionary
        myDict = NSDictionary(contentsOfFile: filePath)!
        let value = myDict["AppleShowAllFiles"]
        let state = value as! String
        
        if state=="YES" || state=="1" {
            print("State is: \(state)")
            let icon = NSImage(named: "showIcon")
            statusItem.image = icon
            statusItem.menu = statusMenu
        } else {
            print("State is: \(state)")
            let icon = NSImage(named: "hideIcon")
            statusItem.image = icon
            statusItem.menu = statusMenu
        }
        
    }
    
    // click toggle menu item
    @IBAction func clickToggleShowHide(_ sender: NSMenuItem) {
        let filePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0].appending("/Preferences/com.apple.finder.plist")
        let myDict: NSDictionary
        myDict = NSDictionary(contentsOfFile: filePath)!
        let value = myDict["AppleShowAllFiles"]
        let state = value as! String
        
        if state=="YES" || state=="1" {
            let icon = NSImage(named: "hideIcon")
            statusItem.image = icon
            statusItem.menu = statusMenu
        } else {
            print("State is: \(state)")
            let icon = NSImage(named: "showIcon")
            statusItem.image = icon
            statusItem.menu = statusMenu
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

