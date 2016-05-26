//
//  AuthenticationState.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

public struct AuthenticationState: AuthenticationStateType {
	public var authenticationToken: String?
	public var authenticatedUser: User?
	
	public init(authenticationToken: String? = nil, authenticatedUser: User? = nil) {
		self.authenticationToken = authenticationToken
		self.authenticatedUser = authenticatedUser
	}
}
