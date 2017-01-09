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
	
	static func cocoaBlocModelSerializer<T: Decodable>(
		_ type: T.Type,
		keyPath: String) -> ResponseSerializer<T, API.Error> where T.DecodedType == T {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.ErrorInfo.decode) {
					return .failure(.api(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap(T.decode) {
				case .success(let model):
					return .success(model)
				case .failure(let decodeError):
					return .failure(.jsonDecoding(decodeError))
				}
			case .failure(let error):
				return .failure(.underlying(error))
			}
		}
	}
	
	static func cocoaBlocModelSerializer<T: Decodable>(
		_ type: T.Type,
		keyPath: String) -> ResponseSerializer<[T], API.Error> where T.DecodedType == T {
		return ResponseSerializer { request, response, data, error in
			switch JSONResponseSerializer().serializeResponse(request, response, data, error) {
			case .success(let jsonObject):
				let json = JSON(jsonObject)
				
				// Assuming this is an unvalidated-by-status-code request, check for our JSON error data to validate
				if case .success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.ErrorInfo.decode) {
					return .failure(.api(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap([T].decode) {
				case .success(let model):
					return .success(model)
				case .failure(let decodeError):
					return .failure(.jsonDecoding(decodeError))
				}
			case .failure(let error):
				return .failure(.underlying(error))
			}
		}
	}
	
}
