//
//  Endpoint.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/28/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Alamofire

public struct Endpoint<Serialized> {
    
    public let path: String
    public let method: Alamofire.Method
    
    public var expansions: [API.ExpandableValue]
    public var parameters: [String:AnyObject]
    
    /// Key path in the response to parse Serialized from
    public var keyPath: String
    
//    public var authenticationTokenKeyPath: String?
    
    init(path: String,
        method: Alamofire.Method,
        expansions: [API.ExpandableValue] = [],
        parameters: [String:AnyObject] = [:],
        keyPath: String = "data") {
            self.path = path
            self.method = method
            self.expansions = expansions
            self.parameters = parameters
            self.keyPath = keyPath
    }
}