//
//  SwiftSWOTConfig.swift
//  
//
//  Created by Khan Winter on 1/5/21.
//

import Foundation
import Vapor

public struct SwiftSWOTConfig {
    
    // Toggles is logging enabled
    public var loggingEnabled: Bool = false
    
    // Array of domains to disallow
    public var blacklist: [String]
    
    /// Dictionary of custom domains that are valid,
    public var trustedDomains: [String: String]
    
    public init(loggingEnabled: Bool = false, blacklist: [String] = [], trustedDomains: [String: String] = [:]) {
        self.loggingEnabled = loggingEnabled
        self.blacklist = blacklist
        self.trustedDomains = trustedDomains
    }
    
}
