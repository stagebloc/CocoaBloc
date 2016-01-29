//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public struct AuthenticationState: AuthenticationStateType {
	public var authenticationToken: String?
	public var authenticatedUser: SBUser?
}

public final class Client {
	
	private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
	private let manager: Manager
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	public private(set) var authenticationState: AuthenticationStateType
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationState: AuthenticationStateType = AuthenticationState(),
		manager: Manager = .init()) {
		self.clientID = clientID
		self.manager = manager
		self.clientSecret = clientSecret
		self.authenticationState = authenticationState
	}
	
	public var authenticated: Bool {
		return self.authenticationState.authenticationToken != nil
	}
	
	internal func request<Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = []) -> Request {
		var params: [String: AnyObject] = [
			"expand": (["kind"] + (expansions + endpoint.expansions)
				.map { $0.rawValue })
				.joinWithSeparator(",")
		]
		for (key, value) in endpoint.parameters {
			params[key] = value
		}
		
		if !self.authenticated {
			params["client_id"] = clientID
		}
		
		let request = manager.request(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			parameters: params,
			encoding: .URL,
			headers: self.authenticated
						? ["Authorization": "Token token=\(authenticationState.authenticationToken)"]
						: nil
			).validate()
		
		endpoint.sideEffect?(request, &self.authenticationState)
		
		return request
	}
	
	public func request<Serialized: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<Serialized, CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func request<Serialized: SequenceType where Serialized.Generator.Element: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<[Serialized.Generator.Element], CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
			completionHandler: completion
		)
	}
	
}
