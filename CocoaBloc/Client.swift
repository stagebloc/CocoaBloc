//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Argo
import Alamofire
import ReactiveCocoa

public enum Error: ErrorType {
    
}

public struct User {
    let identifier: Int
    let email: String
}

private extension Alamofire.Request {
    
}

public class Request<T: Decodable> {
    public typealias Model = T
    private let request: Alamofire.Request
    
    private init(request: Alamofire.Request) {
        self.request = request
    }
    
    public func start(completion: Result<T, Error>) {
        request.responseJSON { response in
            
        }
    }
}

public class Client {
    
    public var authToken: String? = nil
    
    public var authenticated: Bool {
        if let token = authToken {
            return token.characters.count > 0
        }
        return  false
    }
    
    
    public func logInWithUsername(username: String, password: String) -> Request<User> {
        
    }
}