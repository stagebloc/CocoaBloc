//
//  Identifiable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

/// Describes a type which has a single integer identifier
public protocol Identifiable {
	var identifier: Int { get }
}
