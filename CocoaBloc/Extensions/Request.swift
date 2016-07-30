//
//  Request.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry
import Alamofire
import Foundation

public struct APIError: Decodable, Equatable {
	
	public enum Type: String, Decodable {
		case InvalidData		= "InvalidData"
		case NotFound			= "NotFound"
		case DatabaseError		= "DatabaseError"
		case UserNotAuthorized	= "UserNotAuthorized"
		case InvalidRoute		= "InvalidRoute"
		case MissingData		= "MissingData"
		case InvalidLogin		= "InvalidLogin"
	}
	
	public let type: Type
	public let descriptiveText: String
	public let devNotes: String?
	
	public static func decode(metadata: JSON) -> Decoded<APIError> {
		return curry(APIError.init)
			<^> metadata <| "error_type"
			<*> metadata <| "error"
			<*> metadata <|? "dev_notes"
	}
	
}

public func == (lhs: APIError, rhs: APIError) -> Bool {
	return lhs.type == rhs.type && lhs.descriptiveText == rhs.descriptiveText && lhs.devNotes == rhs.devNotes
}

extension Request {
	
	static func cocoaBlocModelSerializer<T: Decodable where T.DecodedType == T>(
		type: T.Type,
		keyPath: String) -> ResponseSerializer<T, Error> {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .Success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .Success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(APIError.decode) {
					return .Failure(.API(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap(T.decode) {
				case .Success(let model):
					return .Success(model)
				case .Failure(let decodeError):
					return .Failure(.JSONDecoding(decodeError))
				}
			case .Failure(let error):
				return .Failure(.Underlying(error))
			}
		}
	}
	
	static func cocoaBlocModelSerializer<T: Decodable where T.DecodedType == T>(
		type: T.Type,
		keyPath: String) -> ResponseSerializer<[T], Error> {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .Success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .Success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(APIError.decode) {
					return .Failure(.API(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap([T].decode) {
				case .Success(let model):
					return .Success(model)
				case .Failure(let decodeError):
					return .Failure(.JSONDecoding(decodeError))
				}
			case .Failure(let error):
				return .Failure(.Underlying(error))
			}
		}
	}
	
}
