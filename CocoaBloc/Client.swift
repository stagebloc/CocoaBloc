//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public protocol AuthenticationStateType {
    var authenticationToken: String? { get set }
    var authenticatedUser: SBUser? { get set }
}

public struct AuthenticationState: AuthenticationStateType {
    public var authenticationToken: String?
    public var authenticatedUser: SBUser?
}

public final class Client {
        
    public let clientID: String
    public let clientSecret: String
    
    public private(set) var authenticationState: AuthenticationStateType
    
    public init(
        clientID: String,
        clientSecret: String,
        authenticationState: AuthenticationStateType = AuthenticationState()) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authenticationState = authenticationState
    }
    
    var authenticated: Bool {
        return self.authenticationState.authenticationToken != nil
    }
    
//    internal func request<Model>(
//        path path: String,
//        method: Alamofire.Method,
//        expand: [ExpandableValue],
//        parameters: [String:AnyObject]? = nil,
//        keyPath: String = "data") -> Request<Model> {
//        let request = manager.request(
//            method,
//            baseURL.URLByAppendingPathComponent(path),
//            parameters: (parameters ?? [:]).map { (var params) in
//                if !self.authenticated {
//                    params["client_id"] = self.clientID
//                }
//                
//                params["expand"] = (["kind"] + expand.map { $0.rawValue }).joinWithSeparator(",")
//                
//                return params
//            },
//            encoding: .URL,
//            headers: nil
//        ).validate()
//        
//        return Request(request: request, keyPath: keyPath)
//    }
}
