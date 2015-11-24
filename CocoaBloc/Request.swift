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

public class Response {
    
}

extension Request where Endpoint.Model: MTLModel {
    /// Starts the request, returning the serialized model for the endpoint if successful
    public func start(completion: Result<Endpoint.Model, Error> -> Void) {
        precondition(endpoint.isArray == false, "This version of start() is only available for non-array endpoints")
        
        return start { (result: Result<[String:AnyObject], Error>) in
            switch result {
            case .Success(let json):
                guard let modelDict = json["data"] as? [NSObject:AnyObject] else {
                    completion(.Failure(.UnexpectedResponseType))
                    return
                }
                
                do {
                    let model = try MTLJSONAdapter.modelOfClass(Endpoint.Model.self, fromJSONDictionary: modelDict) as! Endpoint.Model
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
    public func start(completion: Result<[Endpoint.Model], Error> -> Void) {
        precondition(endpoint.isArray == true, "This version of start() is only available for array endpoints")
        
        return start { (result: Result<[String:AnyObject], Error>) in
            switch result {
            case .Success(let json):
                guard let jsonArray = json["data"] as? [AnyObject] else {
                    completion(.Failure(.UnexpectedResponseType))
                    return
                }
                
                do {
                    let models = try MTLJSONAdapter.modelsOfClass(Endpoint.Model.self, fromJSONArray: jsonArray) as! [Endpoint.Model]
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
public struct Request<Endpoint: EndpointType> {
    
    /// The underlying request
    internal let request: Alamofire.Request
    
    /// The endpoint this request targets
    public let endpoint: Endpoint
    
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
    
    public func start() -> SignalProducer<NSData, Error> {
        return SignalProducer.empty.flatMap(.Latest) { _ in
            
        }
    }
}
import ReactiveCocoa