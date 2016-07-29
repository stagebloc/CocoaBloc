//
//  AuthenticationStateType.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/29/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

/// Represents a type that has a mutable interface of authentication properties
public protocol AuthenticationStateType: Decodable {
	
	var authenticationToken: String? { get set }
	var authenticatedUser: User? { get set }
	var isAuthenticated: Bool { get }
	
	init(authenticationToken: String?, authenticatedUser: User?)
	
}

extension AuthenticationStateType {
	
	public var isAuthenticated: Bool {
		return (authenticationToken?.characters.count > 0) ?? false
	}
	
}

extension AuthenticationStateType {
	
	public static func decode(json: JSON) -> Decoded<Self> {
		return curry(Self.init)
			<^> (json <| "access_token").map(Optional.init)
			<*> (json <| "user").map(Optional.init)
	}

}
