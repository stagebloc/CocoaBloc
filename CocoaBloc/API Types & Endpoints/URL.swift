//
//  URL.swift
//  CocoaBloc
//
//  Created by John Heaton on 8/1/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Foundation

/// A type containing a single URL. This is used instead of NSURL directly
/// so that we don't occupy the public Decodable conformance with our own implementation.
public struct URL {
	public let url: NSURL
}
