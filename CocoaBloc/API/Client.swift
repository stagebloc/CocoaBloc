//
//  Client.swift
//  CocoaBloc
//
//  Created by David Warner on 10/6/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import ReactiveCocoa
import ReactiveMoya
import Result
import Foundation

// NSError domain
public let SBErrorDomain: String = "com.stagebloc.cocoabloc"

/// Meaningful error codes used by Client
@objc public enum SBErrorCode: Int {
    case UnexpectedResponseType
    case IncorrectDeserializedModelType
}

public final class Client {
    
    /// StageBloc API provider used for request generation
    private var provider: ReactiveCocoaMoyaProvider<API>!
    
    // Application-wide auth parameters
    public static var ClientID: String?
    public static var ClientSecret: String?
    public static var RedirectURI: String?
    
    /// Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    /// Authentication state derived from token
    public let authenticated: AnyProperty<Bool>
    
    /// The currently authenticated user
    public let authenticatedUser = MutableProperty<SBUser?>(nil)
    

    public init() {
        precondition(Client.ClientID != nil && Client.ClientSecret != nil)
        
        authenticated = AnyProperty(initialValue: false, producer: token.producer.map { token in token != nil })
        provider = ReactiveCocoaMoyaProvider(endpointClosure: targetToEndpoint)
    }
    
    public func deauthenticate() {
        self.token.value = nil
    }

    /**
     
    */
    public func requestJSON(target: API) -> SignalProducer<[String:AnyObject], NSError> {
        return provider
            .request(target)
            
            // flatMap responses with non-successful status codes into error signals
            .filterSuccessfulStatusAndRedirectCodes()
            
            // Attempt deserializing into generic JSON object
            .mapJSON()
            
            // Attempt mapping JSON object to JSON dictionary. 
            // All StageBloc requests should return responses with dictionary root objects.
            .attemptMap { (value: AnyObject) -> Result<[String:AnyObject], NSError> in
                return Result(value as? [String:AnyObject], failWith: NSError(domain: SBErrorDomain, code: SBErrorCode.UnexpectedResponseType.rawValue, userInfo: nil))
            }
            
            // Hook to map to any inner JSON and inject side effects for updating this client's state
            .flatMap(.Latest, transform: JSONSideEffects(target))
            
            // Set userInfo keys based on the metadata.error key path
            .mapError { error -> NSError in
                var userInfo = error.userInfo
             
                if
                let response = error.userInfo["data"] as? MoyaResponse,
                let responseJSON = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments),
                let responseDict = responseJSON as? [String:AnyObject],
                let metadata = responseDict["metadata"] as? [String:AnyObject],
                let error = metadata["error"] {
                        userInfo[NSLocalizedFailureReasonErrorKey] = error
                }
                
                return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
            }
    }
    
    public func requestJSON<ModelType: MTLModel>(target: API) -> SignalProducer<ModelType, NSError> {
        return tryGetJSONObjectForKey(requestJSON(target), key: "data")
            .attemptMap { (value: [NSObject:AnyObject]) -> Result<ModelType, NSError> in
                do {
                    return Result(try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: value) as? ModelType, failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 7, userInfo: nil))
                }
                catch let error as NSError {
                    return .Failure(error)
                }
            }
    }
    
    public func requestJSON<ModelType: MTLModel>(target: API) -> SignalProducer<[ModelType], NSError> {
        return tryGetJSONObjectForKey(requestJSON(target), key: "data")
            .attemptMap { (value: [AnyObject]) -> Result<[ModelType], NSError> in
                do {
                    return Result(try MTLJSONAdapter.modelsOfClass(ModelType.self, fromJSONArray: value) as? [ModelType], failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 7, userInfo: nil))
                }
                catch let error as NSError {
                    return .Failure(error)
                }
            }
    }
}