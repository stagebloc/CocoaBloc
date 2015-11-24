//
//  EndpointType.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Alamofire
import Mantle

/// Represents a type whose value can represent an API endpoint,
/// with a specified model type to serialize to
public protocol EndpointType {
    
    /// The model type this endpoint serializes to
    typealias Model: MTLModel
    
    /// Whether or not the response for this endpoint serializes to an array of Model
    var isArray: Bool { get }
    
    /// Self-generated request
    func requestWithParameters(params: [String:AnyObject]) -> Alamofire.Request
}