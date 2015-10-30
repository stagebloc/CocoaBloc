//
//  Client+Private.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/29/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import ReactiveMoya
import ReactiveCocoa
import Result

extension Client {
    
    internal func targetToEndpoint(target: API) -> ReactiveMoya.Endpoint<API> {
        
        // Create initial endpoint
        var endpoint = Endpoint<API>(
            URL: target.baseURL.URLByAppendingPathComponent(target.path).absoluteString,
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
    
    internal func tryGetJSONObjectForKey<T>(producer: SignalProducer<[String:AnyObject], NSError>, key: String) -> SignalProducer<T, NSError> {
        return producer
            // try to access `value` as a dictionary, and then dict[key] as T
            .attemptMap { value -> Result<T, NSError> in
                return Result(value[key] as? T, failWith: NSError(domain: "com.stagebloc.cocoabloc", code: 6, userInfo: nil))
        }
    }
}