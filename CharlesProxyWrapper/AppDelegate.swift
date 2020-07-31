//
//  AppDelegate.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import AppKit
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    // TODO: - add attribution: see https://www.freepik.com/free-icon/cube-mop-clean_752833.htm#page=1&query=mop&position=8 
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        func setupStatusItem() {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
            
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
