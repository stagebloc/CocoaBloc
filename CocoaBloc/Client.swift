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
    
    private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
    private let manager: Manager
        
    public let clientID: String
    public let clientSecret: String
    
    public private(set) var authenticationState: AuthenticationStateType
    
    public init(
        clientID: String,
        clientSecret: String,
        authenticationState: AuthenticationStateType = AuthenticationState(),
        manager: Manager = .init()) {
            self.clientID = clientID
            self.manager = manager
            self.clientSecret = clientSecret
            self.authenticationState = authenticationState
    }
    
    public var authenticated: Bool {
        return self.authenticationState.authenticationToken != nil
    }
    
    public func request<Serialized: MTLModel>(
        endpoint: Endpoint<Serialized>,
        expansions: [StageBloc.ExpandableValue] = [],
        completion: Response<Serialized, CocoaBloc.Error> -> ()) {
            var params = ["expand": (["kind"] + expansions.map { $0.rawValue }).joinWithSeparator(",")]
            if !self.authenticated {
                params["client_id"] = clientID
            }
            
            let request = manager.request(
                endpoint.method,
                baseURL.URLByAppendingPathExtension(endpoint.path),
                parameters: params,
                encoding: .URL,
                headers: self.authenticated ? ["Authorization": "Token token=\(authenticationState.authenticationToken)"] : nil
            ).validate()
            
            
    }
    
}
