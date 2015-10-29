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

public final class Client {
    
    private var provider: ReactiveCocoaMoyaProvider<API>!
    
    // Application-wide auth parameters
    public static var ClientID: String?
    public static var ClientSecret: String?
    
    // Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    // Authentication state derived from token
    public let authenticated: AnyProperty<Bool>
    
    public init() {
        precondition(Client.ClientID != nil && Client.ClientSecret != nil)
        
        authenticated = AnyProperty(initialValue: false, producer: token.producer.map { token in token != nil })
        provider = ReactiveCocoaMoyaProvider(endpointClosure: targetToEndpoint)
    }

    public func requestJSON(target: API) -> SignalProducer<AnyObject, NSError> {
        return provider
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
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

extension Client {
    
    private func targetToEndpoint(target: API) -> ReactiveMoya.Endpoint<API> {
        
        // Create initial endpoint
        var endpoint = Endpoint<API>(
            URL: url(target),
            sampleResponseClosure: { EndpointSampleResponse.NetworkResponse(200, target.sampleData) },
            method: target.method,
            parameters: target.parameters
        )
        
        var newParameters = [String:AnyObject]()
        
        // Add per-target endpoint parameters
        switch target {
        case .LogInWithUsername, .LoginWithAuthorizationCode:
            newParameters["client_secret"] = Client.ClientSecret
            newParameters["include_admin_accounts"] = true
            
        default: ()
        }
        
        // Ensure that the `expand` csv parameter always contains kind
        var expansions = (endpoint.parameters?["expand"] as? String) ?? ""
        if !expansions.containsString("kind") {
            expansions += ",kind"
            newParameters["expand"] = expansions
        }
        
        // Ensure that unauthenticated requests have the client_id parameter
        if !self.authenticated.value {
            newParameters["client_id"] = Client.ClientID
        }
        
        // Append all the new parameters
        endpoint = endpoint.endpointByAddingParameters(newParameters)
        
        return endpoint
    }
    
    private func modelPostProcessing<ModelType: MTLModel>(target: API, producer: SignalProducer<ModelType, NSError>) -> SignalProducer<ModelType, NSError> {
        return producer.on(
            completed: {
                switch target {
                case .LogInWithUsername:
                    self.token.value = "potato"
                default: ()
                }
            }
        )
    }
    
    private func tryGetJSONObjectForKey<T>(producer: SignalProducer<AnyObject, NSError>, key: String) -> SignalProducer<T, NSError> {
        return producer
            // try to access `value` as a dictionary, and then dict[key] as T
            .attemptMap { value -> Result<T, NSError> in
                let dictValue = (value as? [String:AnyObject]).flatMap { $0[key] as? T }
                return Result(dictValue, failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 6, userInfo: nil))
        }
    }
    
    private func url(route: MoyaTarget) -> String {
        return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
    }
}