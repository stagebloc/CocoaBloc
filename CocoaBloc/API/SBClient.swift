//
//  SBClient.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/26/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import ReactiveCocoa

public class SBClient: NSObject {
    private let client = Client()
    
    @objc(isAuthenticated) public dynamic var authenticated: Bool = false
    public dynamic var token: String?
    
    override init() {
        super.init()
        
        DynamicProperty(object: self, keyPath: "token") <~ client.token.producer.map { $0.map { $0 as AnyObject } }
    }
    
    public func logInWithUsername(username: String, password: String) -> RACSignal {
        return toRACSignal(client.requestJSON(.LogInWithUsername(username: username, password: password)))
    }
}
