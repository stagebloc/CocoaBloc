//
//  API+Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension API {
	
	public enum Error: ErrorType {
		case JSONDecoding(DecodeError)
		case UnexpectedResponseType
		case API(ErrorInfo)
		case Underlying(NSError)
		case MultipartDataEncoding
	}
	
	public struct ErrorInfo {
		
		public enum ErrorType: String, Decodable {
			case InvalidData		= "InvalidData"
			case NotFound			= "NotFound"
			case DatabaseError		= "DatabaseError"
			case UserNotAuthorized	= "UserNotAuthorized"
			case InvalidRoute		= "InvalidRoute"
			case MissingData		= "MissingData"
			case InvalidLogin		= "InvalidLogin"
		}
		
		public let type: ErrorType
		public let descriptiveText: String
		public let devNotes: String?
		
	}

}

extension API.ErrorInfo: Decodable {
	
	public static func decode(metadata: JSON) -> Decoded<API.ErrorInfo> {
		return curry(API.ErrorInfo.init)
			<^> metadata <| "error_type"
			<*> metadata <| "error"
			<*> metadata <|? "dev_notes"
	}
	
}

extension API.ErrorInfo: Equatable { }
public func == (lhs: API.ErrorInfo, rhs: API.ErrorInfo) -> Bool {
	return lhs.type == rhs.type && lhs.descriptiveText == rhs.descriptiveText && lhs.devNotes == rhs.devNotes
}

extension API.Error: Equatable { }
public func == (lhs: API.Error, rhs: API.Error) -> Bool {
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

extension API.Error: CustomStringConvertible {
	
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
