//
//  NetworkServices.swift
//  Charles Janitor
//
//  Created by Patrick Gatewood on 7/31/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Foundation

/// Network services we're interested in resetting. For all available network services, run
/// `networksetup -listallnetworkservices` in your shell.
enum NetworkService: String, CaseIterable {
    case wifi = "Wi-Fi"
    case vpn = "WillowTreeMain" // TODO: Let the user pick their VPN by name
}
