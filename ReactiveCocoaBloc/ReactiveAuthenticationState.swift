//
//  ReactiveAuthenticationState.swift
//  ReactiveCocoaBloc
//
//  Created by John Heaton on 8/1/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import ReactiveSwift

public typealias ReactiveClient = Client<ReactiveAuthenticationStateContainer>

public final class ReactiveAuthenticationStateContainer: AuthenticationStateContainer {
	
	public var stateProperty = MutableProperty<AuthenticationState>(.unauthenticated)
	
	public var state: AuthenticationState {
		get { return stateProperty.value }
		set { stateProperty.swap(newValue) }
	}
	
	public init() { }
	
}
