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
        
        DynamicProperty(object: self, keyPath: "token") <~ client.token.producer.map { $0 }
    }
    
    public func logInWithUsername(username: String, password: String) -> RACSignal {
        return toRACSignal(client.requestJSON(.LogInWithUsername(username: username, password: password)))
    }
    
//    public func signUpWithEmail(email: String, name: String, password: String, birthday: NSDate, gender: String, sourceAccountID: Int) -> RACSignal {
//        guard let gender = API.Gender(rawValue: gender) else {
//            return RACSignal.error(nil)
//        }
//        
//        return toRACSignal(client.requestJSON(.SignUp(email: email, name: name, password: password, birthday: birthday, gender: gender, sourceAccountID: sourceAccountID)))
//    }
    
    public func getCurrentlyAuthenticatedUser() -> RACSignal {
        return toRACSignal(client.requestJSON(.GetCurrentlyAuthenticatedUser))
    }
    
    public func getUserWithID(userID: Int) -> RACSignal {
        return toRACSignal(client.requestJSON(.GetUser(userID: userID)))
    }
    
    public func getAccountWithID(accountID: Int) -> RACSignal {
        return toRACSignal(client.requestJSON(.GetAccount(accountID: accountID)))
    }
    
    public func sendPasswordResetToEmail(email: String) -> RACSignal {
        return toRACSignal(client.requestJSON(.SendPasswordReset(email: email)))
    }
    
    
}
