//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Result
import ReactiveCocoa

// Current workaround to Swift not being able to disambiguate Result module from Result type
import class Alamofire.Request

/// Represents a type whose value can represent an API endpoint,
/// with a specified model type to serialize to
public protocol EndpointType {
    
    /// The model type this endpoint serializes to
    typealias Model: MTLModel
    
    /// Whether or not the response for this endpoint serializes to an array of Model
    var isArray: Bool { get }
    
    /// Self-generated request
    var request: Alamofire.Request { get }
}

public enum Error: ErrorType {
    case JSONSerialization(NSError)
    case UnexpectedResponseType
    case API(String)
    case Underlying(NSError)
}

/// Represents a request for a given endpoint type
public struct Request<Endpoint: EndpointType> {
    
    /// The underlying request
    private let request: Alamofire.Request
    
    /// The endpoint this request targets
    public let endpoint: Endpoint
    
    public init(request: Alamofire.Request, endpoint: Endpoint) {
        self.request = request.validate()
        self.endpoint = endpoint
    }

    /// Starts the request, returning the raw response data if successful
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