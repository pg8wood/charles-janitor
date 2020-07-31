//
//  ProxyManager.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 7/31/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//
import Foundation

enum ProxyManager {
    private static let relevantProxySettingKeys = Set([
        kCFNetworkProxiesHTTPEnable,
        kCFNetworkProxiesHTTPSEnable
    ])
    
    private static var QCFNetworkCopySystemProxySettings: CFDictionary? {
        guard let proxiesSettingsUnmanaged = CFNetworkCopySystemProxySettings() else {
            return nil
        }
        return proxiesSettingsUnmanaged.takeRetainedValue()
    }
    
    private static var filteredProxySettings: [String: Bool] {
        guard let allProxySettings = QCFNetworkCopySystemProxySettings as? [String: AnyObject] else {
            return [:]
        }
        
        return allProxySettings.reduce(into: [String: Bool]()) { proxySettings, entry in
            guard let boolValue = (entry.value as? NSNumber)?.boolValue,
                  relevantProxySettingKeys.contains(entry.key as CFString) else {
                return
            }
            proxySettings[entry.key] = boolValue
        }
    }
    
    static var areAnyProxiesEnabled: Bool {
        filteredProxySettings.values.contains(true)
    }
}
