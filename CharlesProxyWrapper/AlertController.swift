//
//  AlertController.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa

class AlertController {
    
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
    
    static func showGenericOKAlert(title: String, message: String, style: NSAlert.Style = .informational, terminateOnClose: Bool = false) {
        NSApp.setActivationPolicy(.regular)
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = style
        alert.addButton(withTitle: "OK")
        alert.runModal()
        
        NSApp.setActivationPolicy(.accessory)
        
        if terminateOnClose {
            NSApp.terminate(self)
        }
    }
}
