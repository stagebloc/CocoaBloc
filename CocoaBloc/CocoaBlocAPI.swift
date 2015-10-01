//
//  CocoaBlocAPI.swift
//  CocoaBloc
//
//  Created by David Warner on 9/30/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

enum CocoaBlocAPI {

    // Auth
    case loginWithAuthorizationCode(authorizationCode: String)

    case loginUser(username : String,
                   password : String)

    case signupUser(email : String,
                     name : String,
                 password : String,
                 birthday : NSDate,
                   gender : String,
          sourceAccountID : NSNumber)

    // User

// MARK: Account endpoints

    /*!
    Get an account based on an account ID.
    */
    case getAccount(accountID : NSNumber)

    /*!
    Gets all of the accounts associated with the given user identifier,
    with options to filter admin and following accounts.
    */
    case getAccountsForUser(userIdentifier : String,
                    includingAdminAccounts : Bool,
                         followingAccounts : Bool,
                                parameters : NSDictionary)

    /*!
    Creates an account with
    @param name of the new account
    @param url - the url which this account can be found
    @param type - type of the account being created
    @param color - one of: purple, red, green, blue, orange, grey
    */
    case createAccount(name : String,
                        url : String,
                       type : String,
                      color : String)

    /*!
    Creates an account with
    @param name of the new account
    @param url - the url which this account can be found
    @param type - type of the account being created
    @param photoData - the profile photo of the account
    @param photoProgressSignal - the photo progress upload signal
    */
    case createAccount(name : String,
                        url : String,
                       type : String,
                  photoData : NSData,
        photoProgressSignal : RACSignal,
                 parameters : NSDictionary)

    /*!
    Update an account with one or more new properties.
    NOTE: Only admins of the account are allowed to do this.

    @param name the new account name, or nil
    @param description the new account description, or nil
    @param urlString the new StageBloc URL path component for the account, or nil
    @param type of account (ex. 'Business', 'Cooking', 'Record Label', etc), or nil
    @param account color
    */
    case updateAccount(accountID : NSNumber,
                            name : String,
                     description : String,
                    stageBlocURL : String,
                            type : String,
                           color : String)
    /*!
    Update account photo data
    @param accountIdentifier - identifier of the account for which to update photo
    @param photoData - the profile photo of the account
    @param photoProgressSignal - the photo progress upload signal
    */
    case updateAccountImage(accountID : NSNumber,
                            photoData : NSData,
                       progressSignal : RACSignal)

    /*!
    Get an activity stream of recent content for an account.
    */
    case getActivityStreamForAccount(accountID : NSNumber,
                                    parameters : NSDictionary)

    /*!
    Get a list of users following an account.
    */
    case getFollowingUsersForAccount(accountID : NSNumber,
                                    parameters : NSDictionary)

    /*!
    @param accountId the ID of the parent account
    @param type a specific type of child account to get (optional)
    */
    case getChildrenAccountsForAccount(accountID : NSNumber,
                                            type : String)

    /*!
    Follow an account with its associated identifier
    */
    case followAccount(accountIdentifier : NSNumber)

    /*!
    Unfollow an account with its associated identifier
    */
    case unfollowAccount(accountIdentifier : NSNumber)

    /*!
    Get the currently authenticated user's accounts.
    */
    case getAuthenticatedUserAccounts(parameters : NSDictionary)

    // Content

    // FanClub


    // Store

}

extension CocoaBlocAPI : MoyaTarget {

    // Base URL
    var baseURLString: String { return "https://api.stagebloc.com/v1" }
    var baseURL: NSURL { return NSURL(string: baseURLString)! }

    // Path
    var path: String {
        switch self {

        case
        .loginWithAuthorizationCode,
        .loginUser:
            return "oauth2/token"

        case
        .signupUser:
            return "users"

        // Account
        case
        .getAccount(let accountID):
            return NSString(format: "account/%@", accountID)

        case
        .getAccountsForUser,
        .getAuthenticatedUserAccounts:
            return "accounts"

        case
        .createAccount:
            return "account"

        case
        .updateAccount(let accountID, let name, let description, let stageBlocURL, let type, let color):
            return NSString(format: "account/%@", accountID)

        case
        .updateAccountImage(let accountID, let photoData, let progressSignal):
            return NSString(format: "account/%@", accountID)

        case
        .getActivityStreamForAccount(let accountID, let parameters):
            return NSString(format: "account/%@/content", accountID)

        case
        .getFollowingUsersForAccount(let accountID, let parameters):
            return NSString(format: "account/%@/fans", accountID)

        case
        .getChildrenAccountsForAccount(let accountID, let type):
            return NSString(format: "account/%@/children/%@", accountID, type)

        case
        .followAccount(let accountID):
            return NSString(format: "account/%@/follow", accountID)

        case
        .unfollowAccount(let accountID):
            return NSString(format: "account/%@/follow", accountID)

        default:
            return ""
        }
    }

    // Request type
    var method: Moya.Method {
        switch self {

        case
        .loginWithAuthorizationCode,
        .loginUser,
        .signupUser,

        .createAccount,
        .updateAccount,
        .updateAccountImage,
        .followAccount:
            return .POST

        case
        .getAccount,
        .getAccountsForUser,
        .getAuthenticatedUserAccounts,
        .getActivityStreamForAccount,
        .getFollowingUsersForAccount,
        .getChildrenAccountsForAccount:
            return .GET

        case
        .unfollowAccount:
            return .DELETE

        default:
            return .PUT
        }
    }

    // Sample data
    var sampleData: NSData {
        switch self {

        case loginWithAuthorizationCode:
            return stubbedResponse("Login With Authorization Code")

        case loginUser:
            return stubbedResponse("Login User")

        case signupUser:
            return stubbedResponse("Signup User")

        default:
            return stubbedResponse("")
        }
    }

    // Parameters
    var parameters: [String: AnyObject] {
        switch self {

        case loginWithAuthorizationCode(_):
            return ["" : ""]

//        case loginUser(let username, let password):
//            return []
//
//        case signupUser(let email, let name, let password, let birthday, let gender, let sourceAccountID):
//            return []
        default:
            return ["" : ""]
        }
    }
}

func endpointResolver() -> ((endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest)) {
    return { (endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        return request
    }
}

func stubbedResponse(filename: String) -> NSData! {
        @objc class TestClass: NSObject { }

        let bundle = NSBundle(forClass: TestClass.self)
        let path = bundle.pathForResource(filename, ofType: "json")
        return NSData(contentsOfFile: path!)
}