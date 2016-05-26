//
//  AuthenticationStateType.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/29/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Argo
import Curry

/// Represents a type that has a mutable interface of authentication properties
public protocol AuthenticationStateType: Decodable {
	var authenticationToken: String? { get set }
	var authenticatedUser: User? { get set }
	
	init(authenticationToken: String?, authenticatedUser: User?)
}

extension AuthenticationStateType {
	public static func decode(json: JSON) -> Decoded<Self> {
		return curry(Self.init)
			<^> json <|? "access_token"
			<*> json <|? "user"
	}
}
