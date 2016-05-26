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

        public init(clientID: String, clientSecret: String, redirectURI: String? = nil, testing : Bool? = nil) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.redirectURI = redirectURI
        }
    }
   
    /// The application-wide OAuth app to use. Must be set before initializing a client
    public static var App: Application?
    
    public let testing: Bool
    
    /// Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    /// Authentication state derived from token
    public let authenticated: AnyProperty<Bool>
    
    /// The currently authenticated user
    public let authenticatedUser = MutableProperty<SBUser?>(nil)
    
    
    public init(testing: Bool = false) {
        precondition(Client.App != nil)
        
        self.testing = testing
        authenticated = AnyProperty(
            initialValue: false,
            producer: token.producer.map { $0 != nil }
        )
        provider = ReactiveCocoaMoyaProvider(endpointClosure: targetToEndpoint, stubClosure: stubClosure)
    }
    
    public func deauthenticate() {
        self.token.value = nil
        self.authenticatedUser.value = nil
    }

    /**
     Creates a signal producer which when started will send a request for the given target,
     and whose signals will send the deserialized JSON object returned by the API.
     */
    public func requestJSON(var target: API, expand expansions: [API.ExpandableValue]? = nil) -> SignalProducer<AnyObject, NSError> {
        
        // Apply the `expand` parameter for requested types
        if let expansions = expansions {
            target = .Expanded(target: target, expansions: expansions)
        }
        
        // Map to any inner JSON of the result object signal and perform any side effects needed to update client state
        return JSONSideEffects(target)(jsonSignal: provider
            .request(target)
            
            // flatMap responses with non-successful status codes into error signals
            .filterSuccessfulStatusAndRedirectCodes()
            
            // Attempt deserializing into generic JSON object
            .mapJSON()
            
            // Try accessing "data" key
            // All StageBloc requests should return responses with dictionary root objects
            .attemptMap { (value: AnyObject) -> Result<AnyObject, NSError> in
                let data = (value as? [String:AnyObject])?["data"]
                return Result(data, failWith: SBErrorCode.UnexpectedResponseType.toNSError(nil))
            }
            
            // Set userInfo keys based on the metadata.error key path
            .mapError { (error: NSError) -> NSError in
                var userInfo = error.userInfo
                
                guard
                    let response = error.userInfo["data"] as? MoyaResponse,
                    let responseJSON = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments),
                    let responseDict = responseJSON as? [String:AnyObject],
                    let metadata = responseDict["metadata"] as? [String:AnyObject],
                    let errorReason = metadata["error"] else { return error }
                
                userInfo[NSLocalizedFailureReasonErrorKey] = errorReason
                
                return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
            })
    }
    
    public func requestJSON<ModelType: SBObject>(target: API, expand expansions: [API.ExpandableValue]? = nil) -> SignalProducer<ModelType, NSError> {
        precondition(target.modelType == ModelType.self, "Wrong model \(ModelType.self) type for target. \(target) serializes to \(target.modelType)")
        
        return requestJSON(target, expand: expansions)
            
            // Try mapping the generic AnyObject response into a JSON dictionary type
            .tryOptionalMap(failWith: SBErrorCode.UnexpectedResponseType.toNSError(nil)) { $0 as? [String:AnyObject] }
            
            // Try to parse the JSON into a model
            .tryOptionalMap(failWith: SBErrorCode.IncorrectDeserializedModelType.toNSError(nil)) { json throws -> ModelType? in
                return try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: json) as? ModelType
            }
    }
    
    public func requestJSON<ModelType: SBObject>(target: API, expand expansions: [API.ExpandableValue]? = nil) -> SignalProducer<[ModelType], NSError> {
        precondition(target.modelType == ModelType.self, "Wrong model \(ModelType.self) type for target. \(target) serializes to \(target.modelType)")
        
        return requestJSON(target, expand: expansions)
            
            // Try mapping the generic AnyObject response into an array of objects
            .tryOptionalMap(failWith: SBErrorCode.UnexpectedResponseType.toNSError(nil)) { $0 as? [AnyObject] }
            
            // Try to parse the JSON into a model
            .tryOptionalMap(failWith: SBErrorCode.IncorrectDeserializedModelType.toNSError(nil)) { json throws -> [ModelType]? in
                return try MTLJSONAdapter.modelsOfClass(ModelType.self, fromJSONArray: json) as? [ModelType]
            }
    }
}

extension Client {
    
    private func targetToEndpoint(target: API) -> ReactiveMoya.Endpoint<API> {
        
        // Create initial endpoint
        var endpoint = Endpoint<API>(
            URL: target.URL.absoluteString,
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
    
        // Ensure that unauthenticated requests have the client_id parameter
        if !self.authenticated.value {
            newParameters["client_id"] = Client.App?.clientID
        }
        
        // Ensure that the `expand` csv parameter always contains kind
        var expansions = (endpoint.parameters?["expand"] as? String) ?? ""
        if !expansions.containsString("kind") {
            expansions += ",kind"
            newParameters["expand"] = expansions
        }
        
        // Append all the new parameters
        endpoint = endpoint.endpointByAddingParameters(newParameters)
        
        return endpoint
    }
    
    private func JSONSideEffects(target: API)(jsonSignal: SignalProducer<AnyObject, NSError>) -> SignalProducer<AnyObject, NSError> {
        return jsonSignal
            .on(
                started: { [weak self] in
                    if case .LogInWithUsername = target {
                        self?.deauthenticate()
                    }
                },
                next: { [weak self] json in
                    if case .LogInWithUsername = target {
                        self?.token.value = (json as? [String:AnyObject]).flatMap { $0["access_token"] as? String }
                    }
                },
                failed: { [weak self] error in
                    if case .LogInWithUsername = target {
                        self?.deauthenticate()
                    }
                },
                completed: {
                    
                }
            )
            .map { json in
                if case .LogInWithUsername = target {
                    guard
                        let dataJSON = json as? [String:AnyObject],
                        let userJSON = dataJSON["user"] as? [String:AnyObject] else {
                            return json
                    }
                    
                    return userJSON
                }
                return json
            }
    }

    private func stubClosure(target: API) -> Moya.StubBehavior {
        return testing ? .Immediate : .Never
    }
}