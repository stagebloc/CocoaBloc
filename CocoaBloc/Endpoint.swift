//
//  Endpoint.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/28/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Alamofire

/**
Contains the information about a StageBloc API endpoint,
and all that is needed to create a request for it.
*/
public struct Endpoint<Serialized> {
	
	// HTTP request parts
	public let path: String
	public let method: Alamofire.Method
	public var parameters: [String:AnyObject]
	
	/// Types of objects this endpoint wants expanded from identifiers to full models
	public var expansions: [API.ExpandableValue]
	
	/// Key path in the response to parse Serialized from
	public let keyPath: String
	
	internal init(path: String,
	         method: Alamofire.Method,
	         expansions: [API.ExpandableValue] = [],
	         parameters: [String:AnyObject] = [:],
	         keyPath: String = "data",
	         sideEffect: SideEffectClosure? = nil) {
		self.path = path
		self.method = method
		self.expansions = expansions
		self.parameters = parameters
		self.keyPath = keyPath
		self.sideEffect = sideEffect
	}
	
	internal typealias SideEffectClosure = (Request, inout AuthenticationStateType) -> ()
	internal let sideEffect: SideEffectClosure?
}
