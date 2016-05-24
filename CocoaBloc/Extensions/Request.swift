//
//  Request.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Alamofire

extension Request {
	static func DecodableResponseSerializer<T: Decodable>(type: T.Type, keyPath: String)
		-> ResponseSerializer<T.DecodedType, Error> {
			return ResponseSerializer { request, response, data, error in
				let JSONSerializer = Request.JSONResponseSerializer()
				switch JSONSerializer.serializeResponse(request, response, data, error) {
					
				case .Success(let jsonObject):
					guard let modelObject = jsonObject.valueForKeyPath(keyPath) else {
						return .Failure(.UnexpectedResponseType)
					}
					
					let decodedModel: Decoded<T.DecodedType> = T.decode(JSON(modelObject))
					switch decodedModel {
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
	
	static func DecodableResponseSerializer<T: Decodable where T.DecodedType == T>(type: T.Type, keyPath: String)
		-> ResponseSerializer<[T.DecodedType], Error> {
			return ResponseSerializer { request, response, data, error in
				let JSONSerializer = Request.JSONResponseSerializer()
				switch JSONSerializer.serializeResponse(request, response, data, error) {
					
				case .Success(let jsonObject):
					guard let modelArray = jsonObject.valueForKeyPath(keyPath) as? [AnyObject] else {
						return .Failure(.UnexpectedResponseType)
					}
					
					let decodedModels: Decoded<[T.DecodedType]> = Array<T.DecodedType>.decode(JSON(modelArray))
					switch decodedModels {
					case .Success(let models):
						return .Success(models)
					case .Failure(let decodeError):
						return .Failure(.JSONDecoding(decodeError))
					}
				case .Failure(let error):
					return .Failure(.Underlying(error))
				}
			}
	}
}
