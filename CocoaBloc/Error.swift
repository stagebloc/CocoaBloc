//
//  Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public enum Error: ErrorType {
	case JSONSerialization(NSError)
	case UnexpectedResponseType
	case API(String)
	case Underlying(NSError)
}

extension Error: Equatable { }
public func == (lhs: Error, rhs: Error) -> Bool {
	switch (lhs, rhs) {
	case (.JSONSerialization(let x), .JSONSerialization(let y)) where x == y:
		return true
	case (.UnexpectedResponseType, .UnexpectedResponseType):
		return true
	case (.API(let x), .API(let y)) where x == y:
		return true
	case (.Underlying(let x), .Underlying(let y)) where x == y:
		return true
	default:
		return false
	}
}
