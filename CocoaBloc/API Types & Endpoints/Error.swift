//
//  Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo

public enum Error: ErrorType {
	case JSONDecoding(DecodeError)
	case UnexpectedResponseType
	case API(APIError)
	case Underlying(NSError)
	case MultipartDataEncoding
}

extension Error: Equatable { }
public func == (lhs: Error, rhs: Error) -> Bool {
	switch (lhs, rhs) {
	case (.JSONDecoding(let x), .JSONDecoding(let y)):
		return x == y
	case (.UnexpectedResponseType, .UnexpectedResponseType):
		return true
	case (.API(let x), .API(let y)):
		return x == y
	case (.Underlying(let x), .Underlying(let y)):
		return x == y
	case (.MultipartDataEncoding, .MultipartDataEncoding):
		return true
	default:
		return false
	}
}

extension Error: CustomStringConvertible {

	public var description: String {
		switch self {
		case .UnexpectedResponseType:
			return "Unexpected server response"
		case .Underlying(let error):
			return "Underlying error: \(error)"
		case .JSONDecoding(let decodeError):
			return "JSON Decoding: \(decodeError)"
		case .API(let string):
			return "API Error: \(string)"
		case .MultipartDataEncoding:
			return "Data encoding error"
		}
	}
	
}
