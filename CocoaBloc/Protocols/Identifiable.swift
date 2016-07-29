//
//  Identifiable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public protocol Identifiable {
	associatedtype Identifier
	var identifier: Identifier { get }
}
