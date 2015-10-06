//
//  CocoaBlocAPI+User.swift
//  CocoaBloc
//
//  Created by David Warner on 10/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

extension CocoaBlocAPI {

    // URL path
    public var path: String {
        switch self {

        case
        .signupUser:
            return "users"

        case
        .getCurrentlyAuthenticatedUser:
            return "users/me"

//        case
//        .updateAuthenticatedUser,
//        .updateAuthenticatedUserPhoto:
//            return "users/me"
//
        case
        .getUser(let userID):
            return "users/\(userID)"

        case
        .sendPasswordReset:
            return "users/password/reset"
//
//        case
//        .updateAuthenticatedUserLocation:
//            return "users/me/location/update"
//
        case
        .banUser(let userID, let accountID, _):
            return "users/\(userID)/ban/\(accountID)"

        case
        .getPostedContentFromUser(let userID, let contentListType, _):
            return "users/\(userID)/content/\(contentListType)"

        default :
            return ""
        }
    }

    // Request type
    public var method: Moya.Method {
        switch self {

        case
        .signupUser,
        .banUser,
        .sendPasswordReset:
            //        .updateAuthenticatedUser,
            //        .updateAuthenticatedUserPhoto,
            //        .updateAuthenticatedUserLocation:
            return .POST
        case
        .getCurrentlyAuthenticatedUser,
        .getUser,
        .getPostedContentFromUser:
            return .GET

        default :
            return .GET
        }
    }

    // Sample data
    public var sampleData: NSData {
        switch self {

        case
        .signupUser:
            return stubbedResponse("User")

        default:
            return stubbedResponse("")
        }
    }

    // Parameters
    public var parameters: [String: AnyObject] {
        switch self {

        case .signupUser(let email,
            let name,
            let password,
            let birthday,
            let gender,
            let sourceAccountID):

            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"

            return ["email" : email,
                "name" : name,
                "password" : password,
                "birthday" : df.stringFromDate(birthday),
                "gender" : gender,
                "source_account_id" : sourceAccountID]

        case
        .banUser(_, _, let reason):
            return ["reason" : reason]

        case
        .sendPasswordReset(let email):
            return ["email" : email]

        default:
            /*! Endpoints w/o parameters
            
                .getCurrentlyAuthenticatedUser
                .getUser
            */
            
            return [:]
        }
    }
}