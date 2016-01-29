//
//  Alamofire-Request+MantleSerialization.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/15/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public extension Alamofire.Request {
	
	/// Serializer for a single Mantle model object
	public class func MantleResponseSerializer<Model: MTLModel>(keyPath: String) -> Alamofire.ResponseSerializer<Model, CocoaBloc.Error> {
		return ResponseSerializer { request, response, data, error in
			let JSONSerializer = Alamofire.Request.JSONResponseSerializer()
			switch JSONSerializer.serializeResponse(request, response, data, error) {
				
			case .Success(let jsonObject):
				
				if let data = jsonObject.valueForKeyPath(keyPath) as? [NSObject:AnyObject] {
					do {
						if let model = try MTLJSONAdapter.modelOfClass(Model.self, fromJSONDictionary: data) as? Model {
							return .Success(model)
						} else {
							return .Failure(Error.UnexpectedResponseType)
						}
					}
					catch let error as NSError {
						return .Failure(Error.JSONSerialization(error))
					}
				} else {
					return .Failure(Error.UnexpectedResponseType)
				}
				
			case .Failure(let error):
				return .Failure(Error.Underlying(error))
			}
		}
	}
	
	/// Serializer for an array of Mantle model objects
	public class func MantleResponseSerializer<Model: MTLModel>(keyPath: String) -> Alamofire.ResponseSerializer<[Model], CocoaBloc.Error> {
		return ResponseSerializer { request, response, data, error in
			let JSONSerializer = Alamofire.Request.JSONResponseSerializer()
			switch JSONSerializer.serializeResponse(request, response, data, error) {
				
			case .Success(let jsonObject):
				
				if let data = jsonObject.valueForKeyPath(keyPath) as? [AnyObject] {
					do {
						if let model = try MTLJSONAdapter.modelsOfClass(Model.self, fromJSONArray: data) as? [Model] {
							return .Success(model)
						} else {
							return .Failure(Error.UnexpectedResponseType)
						}
					}
					catch let error as NSError {
						return .Failure(Error.JSONSerialization(error))
					}
				} else {
					return .Failure(Error.UnexpectedResponseType)
				}
				
			case .Failure(let error):
				return .Failure(Error.Underlying(error))
			}
		}
	}
	
}