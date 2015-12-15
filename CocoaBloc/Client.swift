//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire
import ReactiveCocoa

public protocol AuthenticationStateType {
    var authenticationToken: String? { get set }
    var authenticatedUser: SBUser? { get set }
}

public struct AuthenticationState: AuthenticationStateType {
    public var authenticationToken: String?
    public var authenticatedUser: SBUser?
}

public class ReactiveAuthenticationState: AuthenticationStateType {
    public let authenticatedUserProperty = MutableProperty<SBUser?>(nil)
    public let authenticationTokenProperty = MutableProperty<String?>(nil)
    
    public var authenticatedUser: SBUser? {
        get {
            return self.authenticatedUserProperty.value
        }
        set(newValue) {
            self.authenticatedUserProperty.value = newValue
        }
    }
    
    public var authenticationToken: String? {
        get {
            return self.authenticationTokenProperty.value
        }
        set(newValue) {
            self.authenticationTokenProperty.value = newValue
        }
    }
}

public final class Client {
    private let manager: Alamofire.Manager
    private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
    
    public let clientID: String
    public let clientSecret: String
    
    public private(set) var authenticationState: AuthenticationStateType
    
    public init(
        clientID: String,
        clientSecret: String,
        authenticationState: AuthenticationStateType = AuthenticationState(),
        manager: Alamofire.Manager = .init()) {
        self.manager = manager
        self.manager.startRequestsImmediately = false
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authenticationState = authenticationState
    }
    
    var authenticated: Bool {
        return self.authenticationState.authenticationToken != nil
    }
    
    public enum ExpandableValue: String {
        case Photo      = "photo"
        case Photos     = "photos"
        case Account    = "account"
        case User       = "user"
        case Tags       = "tags"
        case Audio      = "audio"
        case CreatedBy  = "created_by"
        case ModifiedBy = "modified_by"
        case Content    = "content"
    }
    
    public enum Gender: String {
        case Male       = "male"
        case Female     = "female"
        case Cupcake    = "cupcake"
    }
    
    public enum ContentTypeIdentifier: String {
        case Photo  = "photo"
        case Audio  = "audio"
        case Video  = "video"
        case Blog   = "blog"
        case Status = "status"
    }
    
    public struct Content: ContentType {
        public let contentType: ContentTypeIdentifier
        public let contentID: Int
        public let postedAccountID: Int
    }
    
    internal func request<Model>(
        path path: String,
        method: Alamofire.Method,
        expand: [ExpandableValue] = [],
        parameters: [String:AnyObject]? = nil,
        keyPath: String = "data") -> Request<Model> {
        let request = manager.request(
            method,
            baseURL.URLByAppendingPathComponent(path),
            parameters: (parameters ?? [:]).map { (var params) in
                if !self.authenticated {
                    params["client_id"] = self.clientID
                }
                
                params["expand"] = (["kind"] + expand.map({$0.rawValue})).joinWithSeparator(",")
                                
//                if !params.keys.contains("expand") {
//                    params["expand"] = "kind"
//                }
//                else if let expansions = params["expand"] as? String where !expansions.containsString("kind") {
//                    params["expand"] = "kind,\(expansions)"
//                }
                
                return params
            },
            encoding: .URL,
            headers: nil
        ).validate()
        
        return Request(request: request, keyPath: keyPath)
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
            ],
            expand: [.User],
            keyPath: "data.user")
        request.request.responseJSON { [weak self] response in
            if
                case .Success(let jsonObject) = response.result,
                let json = jsonObject as? [String:AnyObject],
                let token = json["data"]?["access_token"] as? String {
                    self?.authenticationState.authenticationToken = token
            }
        }
        
        return request
    }
}

public extension SequenceType where Generator.Element == (String, AnyObject?) {
    func filterNil() -> [String:AnyObject] {
        var ret = [String:AnyObject]()
        for tuple in self where tuple.1 != nil {
            ret[tuple.0] = tuple.1!
        }
        return ret
    }
}

