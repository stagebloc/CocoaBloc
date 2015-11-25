//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public class Client {
    private let manager: Alamofire.Manager
    private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
    
    public static var ClientID: String? = nil
    public static var ClientSecret: String? = nil
    
    public init(manager: Alamofire.Manager = .init()) {
        self.manager = manager
        self.manager.startRequestsImmediately = false
    }
    
    public var authenticated: Bool = false
    
    private func request(path path: String, method: Alamofire.Method, parameters: [String:AnyObject]? = nil) -> Alamofire.Request {
        let request = manager.request(
            method,
            baseURL.URLByAppendingPathExtension(path),
            parameters: (parameters ?? [:]).map { (var params) in
                if !self.authenticated {
                    params["client_id"] = Client.ClientID!
                }
                if let expansions = params["expand"] as? String where !expansions.containsString("kind") {
                    params["expand"] = "kind,\(expansions)"
                }
                return params
            },
            encoding: .JSON,
            headers: nil
        )
        return request
    }
    
    public func logInWithUsername(username: String, password: String) -> Request<SBUser> {
        return Request(request: request(
            path: "oauth2/token",
            method: .POST,
            parameters: [
                "username": username,
                "password": password
            ]))
    }
}
