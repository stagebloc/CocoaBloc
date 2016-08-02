//
//  AuthenticationState.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public protocol AuthenticationStateContainer {
	var state: AuthenticationState { get set }
}

public struct CallbackAuthenticationStateContainer: AuthenticationStateContainer {
	
	public var state: AuthenticationState {
		didSet { callback?(state) }
	}
	
	public var callback: Optional<(AuthenticationState) -> ()>
	
}

public enum AuthenticationState {
	
	case unauthenticated
	case authenticated(token: String, user: User?)
	
	public var isAuthenticated: Bool {
		if case .unauthenticated = self {
			return false
		}
		return true
	}
	
	public var token: String? {
		if case .authenticated(let token, _) = self {
			return token
		}
		return nil
	}
	
	public var user: User? {
		if case .authenticated(_, let user) = self {
			return user
		}
		return nil
	}
	
}

import Argo
import Curry

extension AuthenticationState: Decodable {
	
	public static func decode(json: JSON) -> Decoded<AuthenticationState> {
		return curry(AuthenticationState.authenticated)
			<^> (json <| "access_token")
			<*> (json <| "user").map(Optional.init)
	}
	
}
