//
//  CocoaBlocAPI+Account.swift
//  CocoaBloc
//
//  Created by David Warner on 10/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

//extension CocoaBlocAPI {
//
//    /*!
//    Get an account based on an account ID.
//    */
//    case getAccount(accountID : NSNumber)
//
//    /*!
//    Gets all of the accounts associated with the given user identifier,
//    with options to filter admin and following accounts.
//    */
//    case getAccountsForUser(userIdentifier : String,
//        includingAdminAccounts : Bool,
//        followingAccounts : Bool,
//        parameters : NSDictionary)
//
//    /*!
//    Creates an account with
//    @param name of the new account
//    @param url - the url which this account can be found
//    @param type - type of the account being created
//    @param color - one of: purple, red, green, blue, orange, grey
//    */
//    case createAccount(name : String,
//        url : String,
//        type : String,
//        color : String)
//
//    /*!
//    Creates an account with
//    @param name of the new account
//    @param url - the url which this account can be found
//    @param type - type of the account being created
//    @param photoData - the profile photo of the account
//    @param photoProgressSignal - the photo progress upload signal
//    */
//    case createAccount(
//        name: String,
//        url: String,
//        type: String,
//        photoData: NSData,  photoProgressSignal: Signal<Float>, parameters: [String:AnyObject]
//    )
//
//    /*!
//    Update an account with one or more new properties.
//    NOTE: Only admins of the account are allowed to do this.
//
//    @param name the new account name, or nil
//    @param description the new account description, or nil
//    @param urlString the new StageBloc URL path component for the account, or nil
//    @param type of account (ex. 'Business', 'Cooking', 'Record Label', etc), or nil
//    @param account color
//    */
//    case updateAccount(accountID : NSNumber,
//                            name : String,
//                     description : String,
//                    stageBlocURL : String,
//                            type : String,
//                           color : String)
//    /*!
//    Update account photo data
//    @param accountIdentifier - identifier of the account for which to update photo
//    @param photoData - the profile photo of the account
//    @param photoProgressSignal - the photo progress upload signal
//    */
//    case updateAccountImage(accountID : NSNumber,
//                            photoData : NSData,
//                       progressSignal : RACSignal)
//
//    /*!
//    Get an activity stream of recent content for an account.
//    */
//    case getActivityStreamForAccount(accountID : NSNumber,
//        parameters : NSDictionary)
//
//    /*!
//    Get a list of users following an account.
//    */
//    case getFollowingUsersForAccount(accountID : NSNumber,
//        parameters : NSDictionary)
//
//    /*!
//    @param accountId the ID of the parent account
//    @param type a specific type of child account to get (optional)
//    */
//    case getChildrenAccountsForAccount(accountID : NSNumber,
//        type : String)
//
//    /*!
//    Follow an account with its associated identifier
//    */
//    case followAccount(accountIdentifier : NSNumber)
//
//    /*!
//    Unfollow an account with its associated identifier
//    */
//    case unfollowAccount(accountIdentifier : NSNumber)
//
//    /*!
//    Get the currently authenticated user's accounts.
//    */
//    case getAuthenticatedUserAccounts(parameters : NSDictionary)
//}
//
//extension CocoaBlocAPI : MoyaTarget {
//
//    // URL path
//    var path: String {
//        switch self {
//
//        case
//        .getAccount(let accountID):
//            return NSString(format: "account/%@", accountID) as String
//
//        case
//        .getAccountsForUser,
//        .getAuthenticatedUserAccounts:
//            return "accounts"
//
//        case
//        .createAccount:
//            return "account"
//
//        case
//        .updateAccount(let accountID, let _, let _, let _, let _, let _):
//            return NSString(format: "account/%@", accountID) as String
//
//        case
//        .updateAccountImage(let accountID, let photoData, let progressSignal):
//            return NSString(format: "account/%@", accountID) as String
//
//        case
//        .getActivityStreamForAccount(let accountID, let parameters):
//            return NSString(format: "account/%@/content", accountID) as String
//
//        case
//        .getFollowingUsersForAccount(let accountID, let parameters):
//            return NSString(format: "account/%@/fans", accountID) as String
//
//        case
//        .getChildrenAccountsForAccount(let accountID, let type):
//            return NSString(format: "account/%@/children/%@", accountID, type) as String
//
//        case
//        .followAccount(let accountID):
//            return NSString(format: "account/%@/follow", accountID) as String
//
//        case
//        .unfollowAccount(let accountID):
//            return NSString(format: "account/%@/follow", accountID) as String
//
//        default:
//            return ""
//        }
//    }
//
//    // Request type
//    var method: Moya.Method {
//        switch self {
//
//        case
//        .createAccount,
//        .updateAccount,
//        .updateAccountImage,
//        .followAccount:
//            return .POST
//
//        case
//        .getAccount,
//        .getAccountsForUser,
//        .getAuthenticatedUserAccounts,
//        .getActivityStreamForAccount,
//        .getFollowingUsersForAccount,
//        .getChildrenAccountsForAccount:
//            return .GET
//
//        case
//        .unfollowAccount:
//            return .DELETE
//            
//        default:
//            return .PUT
//        }
//    }
//
//    // Sample data
//    var sampleData: NSData {
//        switch self {
//
//        case .getAccount:
//            return stubbedResponse("Login With Authorization Code")
//
//        default:
//            return stubbedResponse("")
//        }
//    }
//
//    // Parameters
//    var parameters: [String: AnyObject] {
//        switch self {
//
//        case .getAccount:
//            return ["" : ""]
//
//        default:
//            return ["" : ""]
//        }
//    }
//
//}
//
//func endpointResolver() -> ((endpoint: Endpoint<Account>) -> (NSURLRequest)) {
//    return { (endpoint: Endpoint<Account>) -> (NSURLRequest) in
//        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
//        return request
//    }
//}
//
//func stubbedResponse(filename: String) -> NSData! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = NSBundle(forClass: TestClass.self)
//    let path = bundle.pathForResource(filename, ofType: "json")
//    return NSData(contentsOfFile: path!)
//}

