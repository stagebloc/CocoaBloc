//
//  Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public enum Error: ErrorType {
	case JSONSerialization(NSError, NSHTTPURLResponse?, NSData?)
	case UnexpectedResponseType(NSHTTPURLResponse?, NSData?)
	case API(String)
	case Underlying(NSError, NSHTTPURLResponse?, NSData?)
}

extension Error: Equatable { }
public func == (lhs: Error, rhs: Error) -> Bool {
	switch (lhs, rhs) {
	case (.JSONSerialization(let x, let y, let z), .JSONSerialization(let t, let u, let v))
		where x == t && y == u && z == v:
			return true
	case (.UnexpectedResponseType(let x, let y), .UnexpectedResponseType(let t, let u)) where x == t && y == u:
		return true
	case (.API(let x), .API(let y)) where x == y:
		return true
	case (.Underlying(let x, let y, let z), .Underlying(let t, let u, let v)) where x == t && y == u && z == v:
		return true
	default:
		return false
	}
}
