//
//  CocoaBlocProvider.swift
//  CocoaBloc
//
//  Created by David Warner on 10/6/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveMoya
import Result

public final class CocoaBlocProvider {
    
    private let provider: ReactiveCocoaMoyaProvider<CocoaBlocAPI>
    
    // Application-wide auth parameters
    public static var ClientID: String?
    public static var ClientSecret: String?
    
    // Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    public init() {
        provider = ReactiveCocoaMoyaProvider(
            endpointClosure: { target -> Endpoint<CocoaBlocAPI> in
                precondition(CocoaBlocProvider.ClientID != nil)
                
                let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
                var endpoint = Endpoint<CocoaBlocAPI>(
                    URL: url,
                    sampleResponseClosure: { EndpointSampleResponse.NetworkResponse(200, target.sampleData) },
                    method: target.method,
                    parameters: target.parameters
                )

                switch target {
                case .LogInWithUsername, .LoginWithAuthorizationCode:
                    precondition(CocoaBlocProvider.ClientSecret != nil)
                    
                    endpoint = endpoint.endpointByAddingParameters([
                        "client_secret": CocoaBlocProvider.ClientSecret!,
                        "include_admin_accounts": true
                    ])
                    
                default: ()
                }
                
                // Ensure that the `expand` csv parameter always contains kind
                var expansions = (endpoint.parameters?["expand"] as? String) ?? ""
                if !expansions.containsString("kind") {
                    expansions += ",kind"
                }
                
                // Ensure that all requests have the client_id parameter
                endpoint = endpoint.endpointByAddingParameters(["client_id": CocoaBlocProvider.ClientID!, "expand": expansions])
                
                return endpoint
            }
        )
    }

    public func requestJSON(target: CocoaBlocAPI) -> SignalProducer<AnyObject, NSError> {
        return provider
            .request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }
    
    public func requestJSON<ModelType: MTLModel>(target: CocoaBlocAPI) -> SignalProducer<ModelType, NSError> {
        return tryGetJSONObjectForKey(requestJSON(target), key: "data").attemptMap { (value: [NSObject:AnyObject]) -> Result<ModelType, NSError> in
            do {
                return Result(try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: value) as? ModelType, failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 7, userInfo: nil))
            }
            catch let error as NSError {
                return .Failure(error)
            }
        }
    }
    
    public func requestJSON<ModelType: MTLModel>(target: CocoaBlocAPI) -> SignalProducer<[ModelType], NSError> {
        return tryGetJSONObjectForKey(requestJSON(target), key: "data").attemptMap { (value: [AnyObject]) -> Result<[ModelType], NSError> in
            do {
                return Result(try MTLJSONAdapter.modelsOfClass(ModelType.self, fromJSONArray: value) as? [ModelType], failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 7, userInfo: nil))
            }
            catch let error as NSError {
                return .Failure(error)
            }
        }
    }
    
    private func tryGetJSONObjectForKey<T>(producer: SignalProducer<AnyObject, NSError>, key: String) -> SignalProducer<T, NSError> {
        return producer
            // try to access `value` as a dictionary, and then dict[key] as T
            .attemptMap { value -> Result<T, NSError> in
                let dictValue = (value as? [String:AnyObject]).flatMap { $0[key] as? T }
                return Result(dictValue, failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 6, userInfo: nil))
            }
    }
}
