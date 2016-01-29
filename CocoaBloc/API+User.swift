//
//  API+User.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension API {
    
	public static func loginWithAuthorizationCode(authorizationCode: String) -> Endpoint<SBUser> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			parameters: [
				"code": authorizationCode,
				"grant_type": "authorization_code"
			],
			sideEffect: { request, authState in
				authState.authenticationToken = nil
				authState.authenticatedUser = nil
				
				request.responseJSON { response in
					switch response.result {
					case .Success(let json):
						if
							let dict = json as? [String:AnyObject],
							let data = dict["data"] as? [String:AnyObject],
							let userData = data["user"] as? [String:AnyObject],
							let token = data["access_token"] as? String {
								do {
									if let user = try MTLJSONAdapter.modelOfClass(SBUser.self, fromJSONDictionary: userData) as? SBUser {
										authState.authenticatedUser = user
										authState.authenticationToken = token
									} else {
										fatalError("Could not set authenticated user and token")
									}
								}
								catch let error as NSError {
									fatalError("Could not set authenticated user and token: \(error)")
								}
						}
					case .Failure(let error):
						fatalError("JSON serialization error \(error)")
					}
				}
			}
		)
	}
	
	public static func logInWithUsername(username: String, password: String) -> Endpoint<SBUser> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			expansions: [.User],
			parameters: [
				"username": username,
				"password": password,
				"grant_type": "password"
			],
			keyPath: "data.user",
			sideEffect: { request, authState in
				authState.authenticationToken = nil
				authState.authenticatedUser = nil
				
				request.responseJSON { response in
					switch response.result {
					case .Success(let json):
						if
							let dict = json as? [String:AnyObject],
							let data = dict["data"] as? [String:AnyObject],
							let userData = data["user"] as? [String:AnyObject],
							let token = data["access_token"] as? String {
								do {
									if let user = try MTLJSONAdapter.modelOfClass(SBUser.self, fromJSONDictionary: userData) as? SBUser {
										authState.authenticatedUser = user
										authState.authenticationToken = token
									} else {
										fatalError("Could not set authenticated user and token")
									}
								}
								catch let error as NSError {
									fatalError("Could not set authenticated user and token: \(error)")
								}
						}
					case .Failure(let error):
						fatalError("JSON serialization error \(error)")
					}
				}
		})
	}
	
	
    public static func getUser(userID: Int) -> Endpoint<SBUser> {
        return Endpoint(
            path: "users/\(userID)",
            method: .GET)
    }
    
    public static func getCurrentlyAuthenticatedUser() -> Endpoint<SBUser> {
        return Endpoint(
            path: "users/me",
            method: .GET)
    }
    
    public static func banUser(userID: Int, accountID: Int, reason: String) -> Endpoint<()> {
        return Endpoint(
            path: "users/\(userID)/ban/\(accountID)",
            method: .POST)
    }
    
    public static func sendPasswordReset(email: String) -> Endpoint<()> {
        return Endpoint(
            path: "users/password/reset",
            method: .POST,
            parameters: [
                "email" : email
            ])
    }
    
    public static func updateUserLocation(latitude: Double, longitude: Double) -> Endpoint<SBUser> {
        return Endpoint(
            path: "users/me/location/update",
            method: .POST,
            parameters: [
                "latitude" : latitude,
                "longitude" : longitude
            ])
    }
    
    public static func updateAuthenticatedUser(
        bio: String?,
        birthday: NSDate?,
        email: String?,
        username: String?,
        name: String?,
        gender: Gender?,
        color: UserColor?) -> Endpoint<SBUser> {
            return Endpoint(
                path: "users/me",
                method: .POST,
                parameters: [
                    "bio"       : bio,
                    "birthday"  : birthday,
                    "email"     : email,
                    "name"      : name,
                    "username"  : username,
                    "gender"    : gender?.rawValue,
                    "color"     : color?.rawValue
                    ].filterNil())
    }
    
    public static func signUp(
        email: String,
        name: String,
        password: String,
        bio: String?,
        birthday: NSDate,
        gender: Gender,
        sourceAccountID: Int?) -> Endpoint<SBUser> {
            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"
            
            return Endpoint(
                path: "users",
                method: .POST,
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
    
    public static func getFollowingUsersForAccount(accountID: Int) -> Endpoint<[SBUser]> {
        return Endpoint(
            path: "account/\(accountID)/fans",
            method: .GET)
    }
    
    public static func getContentForUser(userID: Int, contentListType: ContentListType) -> Endpoint<[SBContent]> {
        return Endpoint(
            path: "users/\(userID)/content/\(contentListType.rawValue)",
            method: .GET)
    }
}
