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

extension Alamofire.DataRequest {
	
	@discardableResult
	func cocoaBlocModelSerializer<T: Decodable>(
		keyPath: String,
		queue: DispatchQueue? = nil,
		completionHandler: @escaping (DataResponse<T>) -> Void) -> Self
		where T.DecodedType == T {
			let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
				guard error == nil else { return .failure(API.APIError.underlying(error!)) }
				
				let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
				let result = jsonSerializer.serializeResponse(request, response, data, nil)
				
				guard case let .success(jsonObject) = result else {
					return .failure(API.APIError.underlying(result.error!))
				}
				
				let json = JSON(jsonObject)
				if case .success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.ErrorInfo.decode) {
					return .failure(API.APIError.api(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap(T.decode) {
				case .success(let model):
					return .success(model)
				case .failure(let decodeError):
					return .failure(API.APIError.jsonDecoding(decodeError))
				}
			}
			
			return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
	
	@discardableResult
	func cocoaBlocModelSerializer<T: Decodable>(
		keyPath: String,
		queue: DispatchQueue? = nil,
		completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
		where T.DecodedType == T {
			let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
				guard error == nil else { return .failure(API.APIError.underlying(error!)) }
				
				let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
				let result = jsonSerializer.serializeResponse(request, response, data, nil)
				
				guard case let .success(jsonObject) = result else {
					return .failure(API.APIError.underlying(result.error!))
				}
				
				let json = JSON(jsonObject)
				if case .success(let apiError) = decodedJSON(json, forKey: "metadata").flatMap(API.ErrorInfo.decode) {
					return .failure(API.APIError.api(apiError))
				}
				
				// Decode the actual data JSON as the decodable type
				switch decodedJSON(json, forKey: keyPath).flatMap([T].decode) {
				case .success(let model):
					return .success(model)
				case .failure(let decodeError):
					return .failure(API.APIError.jsonDecoding(decodeError))
				}
			}
			
			return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
	
}
