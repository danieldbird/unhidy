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
    let statusBar = NSStatusBar.system()
    let menuItem : NSMenuItem = NSMenuItem()
    
    // get com.apple.finder.plist AppleShowAllFiles state
    func getState() -> String {
        let getState = Process()
        getState.launchPath = "/usr/bin/defaults"
        getState.arguments = ["read", "com.apple.finder", "AppleShowAllFiles"]
        let pipe = Pipe()
        getState.standardOutput = pipe
        getState.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!.trimmingCharacters(in: .newlines)
    }
    
    // set menu from current com.apple.finder.plist AppleShowAllFiles state
    func initMenu() {
        if getState()=="NO" || getState()=="0"{
            statusItem.image = NSImage(named: "hideIcon")
            statusMenu.insertItem(withTitle: "Show hidden files", action: #selector(AppDelegate.showFiles(_:)), keyEquivalent: "", at: 0)
        } else {
            statusItem.image = NSImage(named: "showIcon")
            statusMenu.insertItem(withTitle: "Hide hidden files", action: #selector(AppDelegate.hideFiles(_:)), keyEquivalent: "", at: 0)
        }
        statusItem.menu = statusMenu
    }
    
    // sets new menu and com.apple.finder.plist AppleShowAllFiles state
    func setState(icon: String, title: String, action: Selector, show: String) {
        statusItem.image = NSImage(named: icon)
        statusMenu.removeItem(at: 0)
        statusMenu.insertItem(withTitle: title, action: action, keyEquivalent: "", at: 0)
        statusItem.menu = statusMenu
        let setState = Process()
        setState.launchPath = "/usr/bin/defaults"
        setState.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", show]
        setState.launch()
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (timer) in
            let killFinder = Process()
            killFinder.launchPath = "/usr/bin/killall"
            killFinder.arguments = ["Finder"]
            killFinder.launch()
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        initMenu()
    }
    
    @IBAction func hideFiles(_ sender: NSMenuItem) {
        setState(icon: "hideIcon", title: "Show hidden files", action: #selector(AppDelegate.showFiles(_:)), show: "NO")
    }
    
    @IBAction func showFiles(_ sender: NSMenuItem) {
        setState(icon: "showIcon", title: "Hide hidden files", action: #selector(AppDelegate.hideFiles(_:)), show: "YES")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}
