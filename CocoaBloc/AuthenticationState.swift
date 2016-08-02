//
//  AuthenticationState.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public enum AuthenticationState {
	
	case Unauthenticated
	case Authenticated(token: String, user: User?)
	
	public var isAuthenticated: Bool {
		if case .Unauthenticated = self {
			return false
		}
		return true
	}
	
	public var token: String? {
		if case .Authenticated(let token, _) = self {
			return token
		}
		return nil
	}
	
	public var user: User? {
		if case .Authenticated(_, let user) = self {
			return user
		}
		return nil
	}
}

import Argo
import Curry

extension AuthenticationState: Decodable {
	
	public static func decode(json: JSON) -> Decoded<AuthenticationState> {
		return curry(AuthenticationState.Authenticated)
			<^> (json <| "access_token")
			<*> (json <| "user").map(Optional.init)
	}
	
}
