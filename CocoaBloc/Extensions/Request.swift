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

extension Request {
	
	static func cocoaBlocModelSerializer<T: Decodable where T.DecodedType == T>(
		type: T.Type,
		keyPath: String) -> ResponseSerializer<T, API.Error> {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .Success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .Success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.Error.decode) {
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
		keyPath: String) -> ResponseSerializer<[T], API.Error> {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .Success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .Success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.Error.decode) {
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
