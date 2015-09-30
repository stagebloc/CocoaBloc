//
//  CocoaBlocAPI.swift
//  CocoaBloc
//
//  Created by David Warner on 9/30/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Moya

enum CocoaBlocAPI {

    // Auth
    case loginWithAuthorizationCode(authorizationCode: String)
    case loginUser(username : String, password : String)
    case signupUser(email : String, name : String, password : String, birthday : NSDate, gender : String, sourceAccountID : NSNumber)

    // User

    // Account

    // Content
    //    case likeContent(content : SBContent)
    //    case unlikeContent(content : SBContent)

    // FanClub


    // Store

}

extension CocoaBlocAPI : MoyaTarget {

    // Base URL
    var baseURLString: String { "https://api.stagebloc.com/v1" }
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

//        case
//        .likeContent(let content):
//
//            let accountID: NSNumber = content.accountID
//            let identifer: NSNumber = content.identifer
//
//            return String.localizedStringWithFormat("account/%@/%@/%@/like", accountID, "hello", identifer)


        }
    }

    // Request type
    var method: Moya.Method {
        switch self {

        case
        .loginWithAuthorizationCode,
        .loginUser,
        .signupUser:
            return .POST

            //        case
            //            return .HEAD
            //        case
            //            return .PUT
        default:
            return .GET
        }
    }

    // Sample data
//    var sampleData: NSData {
//        switch self {
//
//        case loginWithAuthorizationCode:
//            return stubbedResponse("Login With Authorization Code")
//
//        case loginUser:
//            return stubbedResponse("Login User")
//
//        case signupUser:
//            return stubbedResponse("Signup User")
//        }
//    }

    // Parameters
//    var parameters: [String: AnyObject] {
//        switch self {
//
//        case loginWithAuthorizationCode(let authorizationCode):
//            return []
//
//        case loginUser(let username, let password):
//            return []
//
//        case signupUser(let email, let name, let password, let birthday, let gender, let sourceAccountID):
//            return []
//        }
//    }
}

func endpointResolver() -> ((endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest)) {
    return { (endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        return request
    }
}