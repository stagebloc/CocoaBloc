//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public protocol AuthenticationState {
    var authenticationToken: String? { get set }
    var authenticatedUser: SBUser? { get set }
}

public final class Client {
    private let manager: Alamofire.Manager
    private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
    
    public let clientID: String
    public let clientSecret: String
    
    public let authenticationState: AuthenticationState
    
    public init(clientID: String, clientSecret: String, manager: Alamofire.Manager = .init()) {
        self.manager = manager
        self.manager.startRequestsImmediately = false
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authenticationToken = nil
    }
//    
//    public var authenticationToken: String?
//    
//    public var authenticated: Bool  {
//        return authenticationToken != nil
//    }
    
    public func request<Model: MTLModel>(path path: String, method: Alamofire.Method, parameters: [String:AnyObject]? = nil) -> Request<Model> {
        let request = manager.request(
            method,
            baseURL.URLByAppendingPathComponent(path),
            parameters: (parameters ?? [:]).map { (var params) in
                if !self.authenticated {
                    params["client_id"] = self.clientID
                }
                
                if !params.keys.contains("expand") {
                    params["expand"] = "kind"
                }
                else if let expansions = params["expand"] as? String where !expansions.containsString("kind") {
                    params["expand"] = "kind,\(expansions)"
                }
                return params
            },
            encoding: .URL,
            headers: nil
        ).validate()
        
        return Request(request: request)
    }
    
    public func logInWithUsername(username: String, password: String) -> Request<SBUser> {
        let request: Request<SBUser> = self.request(
            path: "oauth2/token",
            method: .POST,
            parameters: [
                "client_secret": clientSecret,
                "username": username,
                "password": password,
                "grant_type": "password"
            ])
//        request.request.responseJSON { [weak self] response in
//            if
//                case .Success(let jsonObject) = response.result,
//                let json = jsonObject as? [String:AnyObject],
//                let token = json["access_token"] as? String {
//                    self?.authenticationToken = token
//                }
//        }
    
        return request
    }
    
//    public func
}
