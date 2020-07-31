//
//  ProcessRunner.swift
//  CharlesProxyWrapper
//
//  Created by Patrick Gatewood on 6/5/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Foundation

class ProcessRunner {
    /**
     Runs a subprocess and returns its output
     
     - parameter launchPath: The executable to run
     - parameter args: Arguments to pass to the executable
     
     - returns: An optional String with contents of the process' standard output
     */
    @discardableResult
    static func shell(_ launchPath: String, _ args: [String]) -> String? {
        let process = Process()
        process.launchPath = launchPath
        process.arguments = args
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(),  encoding: String.Encoding.utf8)
    }
}
