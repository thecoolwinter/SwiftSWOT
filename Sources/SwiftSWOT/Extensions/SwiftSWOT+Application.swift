//
//  SwiftSWOT+Application.swift
//  
//
//  Created by Khan Winter on 1/5/21.
//

import Vapor

extension Application {
    
    public struct SwiftSWOT {
        
        let app: Application
        
        private final class Storage {
            var configuration: SwiftSWOTConfig?
            
            init() {}
        }
        
        private struct Key: StorageKey {
            typealias Value = Storage
        }
        
        private var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            return app.storage[Key.self]!
        }
        
        public var configuration: SwiftSWOTConfig? {
            get {
                storage.configuration
            }
            nonmutating set { storage.configuration = newValue }
        }
    }
    
    public var SWOT: SwiftSWOT {
        .init(app: self)
    }
    
}
