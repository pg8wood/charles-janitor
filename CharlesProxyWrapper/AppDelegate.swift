//
//  AppDelegate.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let charlesBundleID = "com.xk72.Charles"
    
    private var charlesProcessObserver: NSKeyValueObservation?
    private var charlesInstance: NSRunningApplication?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        guard let charlesURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: charlesBundleID) else {
            AlertController.presentMissingCharlesAlert()
            return
        }
        
        NSWorkspace.shared.openApplication(at: charlesURL, configuration: .init()) { [weak self] charlesInstance, error in
            guard let self = self else { return }
            
            guard let charlesInstance = charlesInstance,
                error == nil else {
                    DispatchQueue.main.async {
                        AlertController.showBugAlert(
                            title: "Failed to open Charles.",
                            message: error?.localizedDescription ?? "Unknown error. 🤷‍♀️ \n\nIf you think this is a bug, please report it on GitHub.",
                            style: .critical,
                            terminateOnClose: true)
                    }
                    return
            }
            
            self.charlesInstance = charlesInstance
            self.charlesProcessObserver = charlesInstance.observe(\.isTerminated, changeHandler: self.observedApplicationIsTerminatedChange(_:isTerminated:))
        }
    }
    
    private func observedApplicationIsTerminatedChange(_ application: NSRunningApplication, isTerminated: NSKeyValueObservedChange<Bool>) {
        func disableProxies() {
            defer {
                NSApp.terminate(self)
            }
            
            let webProxyOutput = ProcessRunner.shell("/usr/sbin/networksetup", ["-setwebproxystate", "Wi-Fi", "off"])
            let secureWebProxyOutput = ProcessRunner.shell("/usr/sbin/networksetup", ["-setsecurewebproxystate", "Wi-Fi", "off"])
            
            if let _ = [webProxyOutput, secureWebProxyOutput]
                .compactMap({ $0 })
                .filter({ !$0.isEmpty })
                .first {
                AlertController.showBugAlert(title: "An error occurred disabling Wi-Fi proxies.", message: "Please report this bug on GitHub.")
            }
        }
        
        guard let charlesInstance = self.charlesInstance ??
            NSRunningApplication.runningApplications(withBundleIdentifier: charlesBundleID).first else {
                disableProxies()
                return
        }
        
        if charlesInstance.isTerminated {
            disableProxies()
        }
    }
}
