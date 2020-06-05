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
    
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        guard let charlesURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: charlesBundleID) else {
            // TODO let user pick their install location or show error
            print("Couldn't find Charles install")
            return
        }

        
        NSWorkspace.shared.openApplication(at: charlesURL, configuration: .init()) { [weak self] charlesInstance, error in
            guard let self = self else { return }
            
            guard let charlesInstance = charlesInstance,
                error == nil else {
                print("failed to open charles")
                return
            }
            
            print("got charles instance with pid: \(charlesInstance.processIdentifier), isTerminated: \(charlesInstance.isTerminated)")
            self.charlesInstance = charlesInstance
            self.charlesProcessObserver = charlesInstance.observe(\.isTerminated, changeHandler: self.observedApplicationIsTerminatedChange(_:isTerminated:))
        }
        // Create the SwiftUI view that provides the window contents.
//        let contentView = ContentView()
//
//        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
    }
    
    private func observedApplicationIsTerminatedChange(_ application: NSRunningApplication, isTerminated: NSKeyValueObservedChange<Bool>) {
        func disableProxies() {
            let webProxyOutput = ProcessRunner.shell("/usr/sbin/networksetup", ["-setwebproxystate", "Wi-Fi", "off"])
            let secureWebProxyOutput = ProcessRunner.shell("/usr/sbin/networksetup", ["-setsecurewebproxystate", "Wi-Fi", "off"])
            
            if let errorMessage = [webProxyOutput, secureWebProxyOutput]
                .compactMap({ $0 })
                .filter({ !$0.isEmpty })
                .first {
                print("error deactivating proxies: \(errorMessage)")
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
