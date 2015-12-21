//
//  Endpoint+User.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension Endpoint {
    
    public func loginWithAuthorizationCode(authorizationCode: String) -> Endpoint<SBUser> {
        return self.request(
            path: "oauth2/token",
            method: .POST,
            expand: [.User],
            parameters: [
                "code": authorizationCode,
                "grant_type": "authorization_code"
            ],
            keyPath: "data.user")
    }
    
    public func logInWithUsername(username: String, password: String) -> Endpoint<SBUser> {
        let request: Request<SBUser> = self.request(
            path: "oauth2/token",
            method: .POST,
            expand: [.User],
            parameters: [
                "client_secret": clientSecret,
                "username": username,
                "password": password,
                "grant_type": "password"
            ],
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
    
    public func getUser(userID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBUser> {
        return self.request(
            path: "users/\(userID)",
            method: .GET,
            expand: expansions)
    }
    
    public func getCurrentlyAuthenticatedUser(expansions: [ExpandableValue] = []) -> Endpoint<SBUser> {
        return self.request(
            path: "users/me",
            method: .GET,
            expand: expansions)
    }
    
    public func banUser(userID: Int, accountID: Int, reason: String) -> Endpoint<()> {
        return self.request(
            path: "users/\(userID)/ban/\(accountID)",
            method: .POST,
            expand: []
        )
    }
    
    public func sendPasswordReset(email: String) -> Endpoint<()> {
        return self.request(
            path: "users/password/reset",
            method: .POST,
            expand: [],
            parameters: [
                "email" : email
            ])
    }
    
    public func updateUserLocation(latitude: Double, longitude: Double, expansions: [ExpandableValue] = []) -> Endpoint<SBUser> {
        return self.request(
            path: "users/me/location/update",
            method: .POST,
            expand: expansions,
            parameters: [
                "latitude" : latitude,
                "longitude" : longitude
            ]
        )
    }
    
    public func updateAuthenticatedUser(
        bio: String?,
        birthday: NSDate?,
        email: String?,
        username: String?,
        name: String?,
        gender: Gender?,
        color: UserColor?,
        expansions: [ExpandableValue] = []) -> Endpoint<SBUser> {
            return self.request(
                path: "users/me",
                method: .POST,
                expand: expansions,
                parameters: [
                    "bio"       : bio,
                    "birthday"  : birthday,
                    "email"     : email,
                    "name"      : name,
                    "username"  : username,
                    "gender"    : gender?.rawValue,
                    "color"     : color?.rawValue
                    ].filterNil()
            )
    }
    
    public func signUp(
        email: String,
        name: String,
        password: String,
        bio: String?,
        birthday: NSDate,
        gender: Gender,
        sourceAccountID: Int?,
        expansions: [ExpandableValue] = []) -> Endpoint<SBUser> {
            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"
            
            return self.request(
                path: "users",
                method: .POST,
                expand: expansions,
                parameters: [
                    "email"     : email,
                    "name"      : name,
                    "bio"       : bio,
                    "password"  : password,
                    "birthday"  : df.stringFromDate(birthday),
                    "gender"    : gender.rawValue,
                    "source_account_id" : sourceAccountID
                    ].filterNil())
    }
    
    public func getFollowingUsersForAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<[SBUser]> {
        return self.request(
            path: "account/\(accountID)/fans",
            method: .GET,
            expand: expansions)
    }
}
