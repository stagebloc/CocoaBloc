//
//  API+Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension API {
	
	public enum APIError: Error {
		case jsonDecoding(DecodeError)
		case api(ErrorInfo)
		case underlying(Error)
		case multipartDataEncoding
	}
	
	public struct ErrorInfo {
		
		public enum ErrorType: String, Decodable {
			case invalidData			= "InvalidData"
			case notFound				= "NotFound"
			case databaseError			= "DatabaseError"
			case userNotAuthorized		= "UserNotAuthorized"
			case invalidRoute			= "InvalidRoute"
			case missingData			= "MissingData"
			case invalidLogin			= "InvalidLogin"
			case unauthorizedGrantType	= "UnauthorizedGrantType"
		}
		
		public let type: ErrorType
		public let descriptiveText: String
		public let devNotes: String?
		
	}

}

extension API.ErrorInfo: Decodable {
	
	public static func decode(_ metadata: JSON) -> Decoded<API.ErrorInfo> {
		return curry(API.ErrorInfo.init)
			<^> metadata <| "error_type"
			<*> metadata <| "error"
			<*> metadata <|? "dev_notes"
	}
	
}

//extension API.ErrorInfo: Equatable { }
//public func == (lhs: API.ErrorInfo, rhs: API.ErrorInfo) -> Bool {
//	return lhs.type == rhs.type && lhs.descriptiveText == rhs.descriptiveText && lhs.devNotes == rhs.devNotes
//}
//
//extension API.APIError: Equatable { }
//public func == (lhs: API.APIError, rhs: API.APIError) -> Bool {
//	switch (lhs, rhs) {
//	case (.jsonDecoding(let x), .jsonDecoding(let y)):
//		return x == y
//	case (.api(let x), .api(let y)):
//		return x == y
//	case (.underlying(let x), .underlying(let y)):
//		return x == y
//	case (.multipartDataEncoding, .multipartDataEncoding):
//		return true
//	default:
//		return false
//	}
//}

extension API.APIError: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .underlying(let error):
			return "Underlying error: \(error)"
		case .jsonDecoding(let decodeError):
			return "JSON Decoding: \(decodeError)"
		case .api(let string):
			return "API Error: \(string)"
		case .multipartDataEncoding:
			return "Data encoding error"
		}
	}
	
}
