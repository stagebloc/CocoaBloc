//
//  AuthenticationState.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-05.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

public enum AuthenticationState: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let token = try container.decodeIfPresent(String.self, forKey: .token) {
			let user = try container.decodeIfPresent(User.self, forKey: .user)
			self = .authenticated(token: token, user: user)
		} else {
			self = .unauthenticated
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .unauthenticated:
			try container.encode("", forKey: .token)
		case .authenticated(let token, let user):
			try container.encode(token, forKey: .token)
			if let user = user {
				try container.encode(user, forKey: .user)
			}
		}
	}
	
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
	
	private enum CodingKeys: String, CodingKey {
		case token = "access_token", user
	}
}
