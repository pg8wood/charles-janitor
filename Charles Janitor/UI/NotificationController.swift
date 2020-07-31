//
//  NotificationController.swift
//  Charles Janitor
//
//  Created by Patrick Gatewood on 7/31/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa

class NotificationController: NSObject, NSUserNotificationCenterDelegate {
    static let shared = NotificationController()
    
    private override init() { super.init() }
    
    func showCleanupNotification() {
        let notification = NSUserNotification()
        
        notification.identifier = UUID().uuidString
        notification.title = "Charles Janitor cleaned up 🧹"
        notification.informativeText = "Charles forgot to disable your proxy settings, but Charles Janitor cleaned up for you."
        
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    // MARK: - NSUserNotificationCenterDelegate
    
    /// Show the notification even if Charles Janitor has focus
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        true
    }
}
