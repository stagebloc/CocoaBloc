//
//  AuthenticationStateType.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/29/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

/// Represents a type that has a mutable interface of authentication properties
public protocol AuthenticationStateType {
	var authenticationToken: String? { get set }
	var authenticatedUser: SBUser? { get set }
}