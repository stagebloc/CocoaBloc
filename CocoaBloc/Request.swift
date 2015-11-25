//
//  Request.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Result
import class Alamofire.Request

extension Request where ModelType: MTLModel {
    /// Starts the request, returning the serialized model for the endpoint if successful
    public func start(completion: Result<ModelType, Error> -> Void) {
        return start { (result: Result<[String:AnyObject], Error>) in
            switch result {
            case .Success(let json):
                guard let modelDict = json["data"] as? [NSObject:AnyObject] else {
                    completion(.Failure(.UnexpectedResponseType))
                    return
                }
                
                do {
                    let model = try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: modelDict) as! ModelType
                    completion(.Success(model))
                }
                catch let error as NSError {
                    completion(.Failure(.JSONSerialization(error)))
                }
                
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
    
    /// Starts the request, returning the array of serialized models for the endpoint if successful
    public func start(completion: Result<[ModelType], Error> -> Void) {
        return start { (result: Result<[String:AnyObject], Error>) in
            switch result {
            case .Success(let json):
                guard let jsonArray = json["data"] as? [AnyObject] else {
                    completion(.Failure(.UnexpectedResponseType))
                    return
                }
                
                do {
                    let models = try MTLJSONAdapter.modelsOfClass(ModelType.self, fromJSONArray: jsonArray) as! [ModelType]
                    completion(.Success(models))
                }
                catch let error as NSError {
                    completion(.Failure(.JSONSerialization(error)))
                }
                
            case .Failure(let error):
                completion(.Failure(error))
            }
        }
    }
}

/// Represents a request for a given endpoint type
public struct Request<ModelType> {
    
    /// The underlying request
    internal let request: Alamofire.Request
    
    public func start(completion: Result<NSData, Error> -> Void) {
        request.responseData { response in
            switch response.result {
            case .Success(let data):
                completion(.Success(data))
            case .Failure(let error):
                completion(.Failure(.Underlying(error)))
            }
        }
    }
    
    /// Starts the request, returning the JSON respresentation of the data if successful
    public func start(completion: Result<[String:AnyObject], Error> -> Void) {
        request.responseJSON { response in
            switch response.result {
            case .Success(let object):
                if let dict = object as? [String:AnyObject] {
                    completion(.Success(dict))
                } else {
                    completion(.Failure(.UnexpectedResponseType))
                }
            case .Failure(let error):
                completion(.Failure(.Underlying(error)))
            }
        }
    }
}