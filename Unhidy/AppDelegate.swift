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
    
    var statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var statusBar = NSStatusBar.system()
    var menuItem : NSMenuItem = NSMenuItem()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Get state of files hidden
        let getState = Process()
        getState.launchPath = "/usr/bin/defaults"
        getState.arguments = ["read", "com.apple.finder", "AppleShowAllFiles"]
        let pipe = Pipe()
        getState.standardOutput = pipe
        getState.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let state = String(data: data, encoding: String.Encoding.utf8)!.trimmingCharacters(in: .newlines)
        
        if state=="NO" || state=="0"{
            statusItem.image = NSImage(named: "hideIcon")
            statusMenu.insertItem(withTitle: "Show hidden files", action: #selector(AppDelegate.showFiles(_:)), keyEquivalent: "", at: 0)
        } else {
            statusItem.image = NSImage(named: "showIcon")
            statusMenu.insertItem(withTitle: "Hide hidden files", action: #selector(AppDelegate.hideFiles(_:)), keyEquivalent: "", at: 0)
        }
        statusItem.menu = statusMenu
    }
    
    @IBAction func hideFiles(_ sender: NSMenuItem) {
        statusItem.image = NSImage(named: "hideIcon")
        statusMenu.removeItem(at: 0)
        statusMenu.insertItem(withTitle: "Show hidden files", action: #selector(AppDelegate.showFiles(_:)), keyEquivalent: "", at: 0)
        statusItem.menu = statusMenu
        let setState = Process()
        setState.launchPath = "/usr/bin/defaults"
        setState.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "NO"]
        setState.launch()
        
        // ensure state is set before restarting finder
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) {
            let killFinder = Process()
            killFinder.launchPath = "/usr/bin/killall"
            killFinder.arguments = ["Finder"]
            killFinder.launch()
        }
    }
    
    @IBAction func showFiles(_ sender: NSMenuItem) {
        statusItem.image = NSImage(named: "showIcon")
        statusMenu.removeItem(at: 0)
        statusMenu.insertItem(withTitle: "Hide hidden files", action: #selector(AppDelegate.hideFiles(_:)), keyEquivalent: "", at: 0)
        statusItem.menu = statusMenu
        let setState = Process()
        setState.launchPath = "/usr/bin/defaults"
        setState.arguments = ["write", "com.apple.finder", "AppleShowAllFiles", "YES"]
        setState.launch()
        
        // ensure state is set before restarting finder
        let when = DispatchTime.now() + 0.05
        DispatchQueue.main.asyncAfter(deadline: when) {
            let killFinder = Process()
            killFinder.launchPath = "/usr/bin/killall"
            killFinder.arguments = ["Finder"]
            killFinder.launch()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

