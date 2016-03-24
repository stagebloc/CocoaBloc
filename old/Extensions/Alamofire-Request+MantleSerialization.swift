//
//  Alamofire-Request+MantleSerialization.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/15/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

private func failureForError<Value>(error: NSError, data: NSData?) -> Result<Value, CocoaBloc.Error> {
	guard let jsonData = data else { return .Failure(Error.Underlying(error)) }
	do {
		let options = NSJSONReadingOptions() // Why can't I just pass .none or something gah
		let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: options)
		if let jsonDictionary = jsonObject as? [String:AnyObject] {
			guard
				let metadata = jsonDictionary["metadata"] as? [String:AnyObject],
				let errorString = metadata["error"] as? String else {
					return .Failure(Error.UnexpectedResponseType)
			}
			return .Failure(Error.API(errorString))
		} else {
			return .Failure(Error.UnexpectedResponseType)
		}
	} catch let error as NSError {
		return .Failure(Error.JSONSerialization(error))
	}
}

public extension Request {
	
	/// Serializer for a single Mantle model object
	public class func MantleResponseSerializer<Model: MTLModel>(keyPath: String) -> Alamofire.ResponseSerializer<Model, CocoaBloc.Error> {
		return ResponseSerializer { request, response, data, error in
			let JSONSerializer = Request.JSONResponseSerializer()
			switch JSONSerializer.serializeResponse(request, response, data, error) {
				
			case .Success(let jsonObject):
				print("json: \(jsonObject)")
				
				if let data = jsonObject.valueForKeyPath(keyPath) as? [NSObject:AnyObject] {
					print("data: \(data)")
					do {
						print("Model type: \(Model.self)")
						if let model = try MTLJSONAdapter.modelOfClass(Model.self, fromJSONDictionary: data) as? Model {
							print("model: \(model)")
							return .Success(model)
						} else {
							return .Failure(Error.UnexpectedResponseType)
						}
					}
					catch let error as NSError {
						print("failure 2: \(error)")
						return .Failure(Error.JSONSerialization(error))
					}
				} else {
					return .Failure(Error.UnexpectedResponseType)
				}
				
			case .Failure(let error):
				print("failure 1: \(error)")
				return failureForError(error, data: data)
			}
		}
	}
	
	/// Serializer for an array of Mantle model objects
	public class func MantleResponseSerializer<Model: MTLModel>(keyPath: String) -> Alamofire.ResponseSerializer<[Model], CocoaBloc.Error> {
		return ResponseSerializer { request, response, data, error in
			let JSONSerializer = Request.JSONResponseSerializer()
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
				return failureForError(error, data: data)
			}
		}
	}
	
}