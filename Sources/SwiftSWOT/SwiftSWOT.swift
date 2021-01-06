//
//  SWOT.swift
//
//
//  Created by Khan Winter on 1/2/21.
//

import Foundation
import Vapor

/**
 # SwiftSWOT
 
 Main class of the service. Has methods `validateEmail(_ email: String)` and   `institutionFromEmail(_ email: String)`
 for checking validity of academic emails.
 
 - Author: Khan Winter
 */
public struct SwiftSWOT {
    
    var req: Request
    
    /**
     # Validate Email
     
     - Parameter email: The email to validate
     - Returns: A `Bool` value indicating whether the email is a valid academic email.
     
     */
    public func validateEmail(_ email: String) -> Bool {
        let logs: Bool = req.application.SWOT.configuration?.loggingEnabled ?? false
        let blacklist: [String] = req.application.SWOT.configuration?.blacklist ?? []
        let trustedDomains: [String: String] = req.application.SWOT.configuration?.trustedDomains ?? [:]
        
        if logs {
            req.logger.info("Validating email \(email)")
        }
        
        // First check if it's a valid email
        if !isValidEmail(email) {
            if logs {
                req.logger.info("Invalid email format.")
            }
            return false
        } else {
            let domain = getDomain(email)
            let domainURL = domainToURL(domain)
            
            // Check if the email is in the config's blacklist or trusted domains
            if blacklist.contains(domain) {
                return false
            } else if trustedDomains[domain] != nil {
                return true
            }
            
            // Check if the email is in the database
            return Bundle.module.path(forResource: "Resources/domains/" + domainURL, ofType: "txt", inDirectory: nil) != nil
        }
    }
    
    /**
     # Institution From Email
     
     - Parameter email: The email to validate
     - Returns: An optional string value. If `nil`, the email isn't a valid academic email.
                If the string isn't nil, it's the title of the academic institution the email belongs to.
     */
    public func institutionFromEmail(_ email: String) -> String? {
        let logs: Bool = req.application.SWOT.configuration?.loggingEnabled ?? false
        let blacklist: [String] = req.application.SWOT.configuration?.blacklist ?? []
        let trustedDomains: [String: String] = req.application.SWOT.configuration?.trustedDomains ?? [:]
        
        if logs {
            req.logger.info("Validating email \(email)")
        }
        
        // First check if it's a valid email
        if !isValidEmail(email) {
            if logs {
                req.logger.info("Invalid email format.")
            }
            return nil
        } else {
            let domain = getDomain(email)
            let domainURL = domainToURL(domain)
            
            // Check if the email is in the config's blacklist or trusted domains
            if blacklist.contains(domain) {
                return nil
            } else if trustedDomains[domain] != nil {
                return trustedDomains[domain]
            }
            
            // Check if the email is in the database
            if let path = Bundle.module.path(forResource: "Resources/domains/" + domainURL, ofType: "txt", inDirectory: nil) {
                return try? String(contentsOfFile: path)
            } else {
                return nil
            }
        }
    }
        
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func getDomain(_ email: String) -> String {
        return email.components(separatedBy: "@").reversed()[0]
    }
    
    private func domainToURL(_ domain: String) -> String {
        var domainURLComponents = domain.components(separatedBy: ".")
        domainURLComponents[0] = domainURLComponents[0]
        let domainURL = domainURLComponents.reversed().joined(separator: "/")
        return domainURL
    }
    
}
