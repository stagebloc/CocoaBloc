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
    case InvalidAppCredentials
    
    public func toNSError(userInfo: [NSObject:AnyObject]?) -> NSError {
        return NSError(domain: SBErrorDomain, code: self.rawValue, userInfo: userInfo)
    }
}


public final class Client {
    
    /// StageBloc API provider used for request generation
    private var provider: ReactiveCocoaMoyaProvider<API>!
    
    /// An OAuth application registered on StageBloc
    public struct Application {
        public var clientID: String
        public var clientSecret: String
        public var redirectURI: String?
        
        public init(clientID: String, clientSecret: String, redirectURI: String? = nil) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.redirectURI = redirectURI
        }
    }
   
    /// The application-wide OAuth app to use. Must be set before initializing a client
    public static var App: Application?
    
    /// Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    /// Authentication state derived from token
    public let authenticated: AnyProperty<Bool>
    
    /// The currently authenticated user
    public let authenticatedUser = MutableProperty<SBUser?>(nil)
    
    
    public init() {
        precondition(Client.App != nil)
        
        authenticated = AnyProperty(initialValue: false, producer: token.producer.map { token in token != nil })
        provider = ReactiveCocoaMoyaProvider(endpointClosure: targetToEndpoint)
    }
    
    public func deauthenticate() {
        self.token.value = nil
    }

    /**
     
    */
    public func requestJSON(target: API) -> SignalProducer<AnyObject, NSError> {
        return provider
            .request(target)
            
            // flatMap responses with non-successful status codes into error signals
            .filterSuccessfulStatusAndRedirectCodes()
            
            // Attempt deserializing into generic JSON object
            .mapJSON()
            
            // Try accessing "data" key
            // All StageBloc requests should return responses with dictionary root objects
            .attemptMap { (value: AnyObject) -> Result<AnyObject, NSError> in
                let data = (value as? [String:AnyObject])?["data"]
                return Result(data, failWith: NSError(domain: SBErrorDomain, code: SBErrorCode.UnexpectedResponseType.rawValue, userInfo: nil))
            }
            
            // Set userInfo keys based on the metadata.error key path
            .mapError { error -> NSError in
                var userInfo = error.userInfo
                
                guard
                    let response = error.userInfo["data"] as? MoyaResponse,
                    let responseJSON = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments),
                    let responseDict = responseJSON as? [String:AnyObject],
                    let metadata = responseDict["metadata"] as? [String:AnyObject],
                    let errorReason = metadata["error"] else { return error }
                
                userInfo[NSLocalizedFailureReasonErrorKey] = errorReason
                
                return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
            }
            
            // Hook to map to any inner JSON and inject side effects for updating this client's state
            .flatMap(.Latest, transform: JSONSideEffects(target))
    }
    
    public func requestJSON<ModelType: SBObject>(target: API) -> SignalProducer<ModelType, NSError> {
        let error = NSError(domain: SBErrorDomain, code: SBErrorCode.IncorrectDeserializedModelType.rawValue, userInfo: nil)
        return requestJSON(target)
            .tryOptionalMap(failWith: error) { $0 as? [String:AnyObject] }
            .tryOptionalMap(failWith: error) { json throws -> ModelType? in
            // Try mapping the generic AnyObject response into a JSON dictionary type
            // Try to parse the JSON into a model
                return try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: json) as? ModelType
            }
    }
    

    public func requestJSON<ModelType: SBObject>(target: API, sortOrder: API.SortOrder, direction: API.Direction) -> SignalProducer<[ModelType], NSError> {
        let error = NSError(domain: SBErrorDomain, code: SBErrorCode.IncorrectDeserializedModelType.rawValue, userInfo: nil)

        return requestJSON(target)
            .tryOptionalMap(failWith: error) { $0 as? [AnyObject] }
            .tryOptionalMap(failWith: error) { json throws -> [ModelType]? in
            // Try mapping the generic AnyObject response into an array of objects
            // Try to parse the JSON into a model
                return try MTLJSONAdapter.modelsOfClass(ModelType.self, fromJSONArray: json) as? [ModelType]
            }
    }
}

extension Client {
    
    private func targetToEndpoint(target: API) -> ReactiveMoya.Endpoint<API> {
        
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
            newParameters["client_secret"] = Client.App?.clientSecret
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
            newParameters["client_id"] = Client.App?.clientID
        }
        
        // Append all the new parameters
        endpoint = endpoint.endpointByAddingParameters(newParameters)
        
        return endpoint
    }
    
    private func JSONSideEffects(target: API)(json: AnyObject) -> SignalProducer<AnyObject, NSError> {
        return SignalProducer(value: json)
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
                        self?.token.value = (json as? [String:AnyObject]).flatMap { $0["access_token"] as? String }
                        
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
                switch target {
                    
                case .LogInWithUsername:
                    guard
                        let dataJSON = json as? [String:AnyObject],
                        let userJSON = dataJSON["user"] as? [String:AnyObject] else {
                            return json
                    }
                    
                    return userJSON
                    
                default:
                    return json
                }
        }
    }
}