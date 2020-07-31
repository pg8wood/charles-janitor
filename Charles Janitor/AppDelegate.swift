//
//  AppDelegate.swift
//  Charles Janitor
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import AppKit
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    @IBOutlet weak var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func setupStatusItem() {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
            statusItem.menu = menu
            
            let icon = NSImage(named: "statusIcon")
            icon?.isTemplate = true
            statusItem.button?.image = icon
        }
        
        NSApp.setActivationPolicy(.accessory)
        NSUserNotificationCenter.default.delegate = NotificationController.shared
        setupStatusItem()
        CharlesRunner.runCharles()
    }
}
