//
//  AlertController.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa

class AlertController {
    private static let bugReportURL = URL(string: "https://github.com/pg8wood/charles-janitor/issues/new?assignees=pg8wood&labels=bug&template=bug-report.md&title=")!
    
    static func presentMissingCharlesAlert() {
        NSApp.setActivationPolicy(.regular)
        
        let alert = NSAlert()
        alert.messageText = "Couldn't find Charles."
        alert.informativeText = "Please make sure Charles is installed."
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            fallthrough
        default:
            NSApp.terminate(self)
        }
    }
    
    /// Shows an alert that an error occurred. Switches to a Dock app while the alert is present and back to a status bar app when the alert is closed
    static func showBugAlert(title: String, message: String, style: NSAlert.Style = .informational, terminateOnClose: Bool = false) {
        var terminateOnClose = terminateOnClose
        
        NSApp.setActivationPolicy(.regular)
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = style
        alert.addButton(withTitle: "Report Bug")
        alert.addButton(withTitle: "Close")
        
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            NSWorkspace.shared.open(bugReportURL)
        case .alertSecondButtonReturn:
            terminateOnClose = true
        default:
            break
        }
        
        NSApp.setActivationPolicy(.accessory)
        
        if terminateOnClose {
            NSApp.terminate(self)
        }
    }
}
