//
//  SwiftSWOT+Request.swift
//  
//
//  Created by Khan Winter on 1/5/21.
//

import Vapor

public extension Request {
    var SWOT: SwiftSWOT {
        .init(req: self)
    }
}
