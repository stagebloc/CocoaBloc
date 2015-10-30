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

/// Meaningful error codes used by Client
@objc enum SBErrorCode: Int {
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
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .attemptMap { (value: AnyObject) -> Result<[String:AnyObject], NSError> in
                return Result(value as? [String:AnyObject], failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 10, userInfo: nil))
            }
            .on(
                started: { [weak self] in
                    switch target {
                        
                    // Reset authentication state immediately when request for new auth is submitted
                    case .LogInWithUsername:
                        self?.deauthenticate()
                        
                    default: ()
                    }
                },
                next: { [weak self] json in
                    switch target {
                        
                    case .LogInWithUsername:
                        self?.token.value = (json["data"] as? [String:AnyObject]).flatMap { $0["access_token"] as? String }
                        
                    default: ()
                    }
                },
                failed: { [weak self] error in
                    switch target {
                        
                    case .LogInWithUsername:
                        self?.deauthenticate()
                        
                    default: ()
                    }
                },
                completed: {
                    
                }
            )
            .map { json in
                return json
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