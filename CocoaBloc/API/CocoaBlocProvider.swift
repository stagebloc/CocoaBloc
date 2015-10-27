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

public final class CocoaBlocProvider: ReactiveCocoaMoyaProvider<CocoaBlocAPI> {
    
    // Application-wide auth parameters
    public static var ClientID: String?
    public static var ClientSecret: String?
    
    // Auth token for this client
    public let token = MutableProperty<String?>(nil)
    
    public init() {
        super.init(
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
                
                var expansions = (endpoint.parameters?["expand"] as? String) ?? ""
                if !expansions.containsString("kind") {
                    expansions += ",kind"
                }
                
                endpoint = endpoint.endpointByAddingParameters(["client_id": CocoaBlocProvider.ClientID!, "expand": expansions])
                
                return endpoint
            }
        )
    }
    
    public func requestJSON<ModelType: MTLModel>(target: CocoaBlocAPI) -> SignalProducer<ModelType, NSError> {
        return request(target).filterSuccessfulStatusAndRedirectCodes().mapJSON().flatMap(.Latest) { jsonObject -> SignalProducer<ModelType, NSError> in
            print(jsonObject)
            guard let dict = jsonObject as? [String:AnyObject], let innerDict = dict["data"] as? [String:AnyObject] else {
                return SignalProducer(error: NSError(domain: "com.stagebloc.cocoabloc", code: 4, userInfo: nil))
            }
            do {
                let model = try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: innerDict) as! ModelType
                return SignalProducer(value: model)
            }
            catch let error as NSError {
                return SignalProducer(error: error)
            }
        }
    }
    
    public func requestJSON<ModelType: MTLModel>(target: CocoaBlocAPI) -> SignalProducer<[ModelType], NSError> {
        return request(target).mapJSON().flatMap(.Latest) { jsonObject -> SignalProducer<[ModelType], NSError> in
            guard let model = jsonObject as? [ModelType] else {
                return SignalProducer(error: NSError(domain: "com.stagebloc.cocoabloc", code: 4, userInfo: nil))
            }
            
            return SignalProducer(value: model)
        }
    }
}
