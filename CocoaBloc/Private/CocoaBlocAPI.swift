//
//  CocoaBlocAPI.swift
//  CocoaBloc
//
//  Created by David Warner on 10/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

public enum CocoaBlocAPI {

    /**
    Complete the log in process with an authorization code from StageBloc, usually obtained from SBAuthenticationController.

    - Parameters:
        - authorizationCode: The authorization code.
    */
    case loginWithAuthorizationCode(authorizationCode : String)

    /**
    Log in a StageBloc user with the given credentials.

    - Parameters:
        - username: The user's username/email address.
        - password: The user's password.
    */
    case logInWithUsername(username : String,
        password : String)

    /**
    Sign up a new StageBloc user with the given user information and desired credentials.

    - Parameters:
        - email: The user's email address.
        - name: The user's name.
        - password: The user's password.
        - birthday: The user's birthday.
        - gender: The user's gender.
        - sourceAccountID: The identifier of the account from which user is signing up.
    */
    case signupUser(email : String,
        name : String,
        password : String,
        birthday : NSDate,
        gender : String,
        sourceAccountID : NSNumber)

    /**
    Request the currently authenticated user for the SBClient.
    */
    case getCurrentlyAuthenticatedUser

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - userID: identifier of user to be requested.
    */
    case getUser(userID : NSNumber)

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - params: NSDictionary containing user information to be updated.
    */
    case updateAuthenticatedUserWithParameters(params : NSDictionary)

    /**
    Ban user from specified account.

    - Parameters:
        - userID: identifier of user to be banned.
        - accountID: identifier of account from which to ban user.
        - reason: String containing a reason why user is to be banned.
    */
    case banUser(userID : NSNumber,
        accountID : NSNumber,
        reason : String)

    /**
    Request a list of content the user has either submitted or liked.

    - Parameters:
        - userID: identifier of user for whose content to fetch.
        - contentListType: specifies either a list of user-submitted content ('SBUserContentListTypeUpdate')
        or user-liked content ('SBUserContentListTypeLike').
        - parameters: additional parameters.
    */
    case getPostedContentFromUser(userID : NSNumber,
        contentListType : String,
        parameters : NSDictionary)

    /**
    Requests password reset to specified email address.

    - Parameters:
        - email: email address to send passoword reset.
    */
    case sendPasswordReset(email : String)

    /**
    Updates user information .
    - Parameters:
        - email: email address to send passoword reset.
    */
//    case updateAuthenticatedUserWithPhoto(parameters : NSDictionary,
//        photoData : NSData,
//        progressSignal : RACSignal)
//
//
//    case updateAuthenticatedUserPhoto(photoData : NSData, progressSignal : RACSignal)
//
//    case updateAuthenticatedUserLocation(coordinates, CLLocationCoordinate2D)

}

extension CocoaBlocAPI : MoyaTarget {

    // Base CocoaBlocAPI URL
    public var baseURL: NSURL { return NSURL(string: "https://api.stagebloc.com/v1")! }

    // URL path
    public var path: String {
        switch self {

        case
        .loginWithAuthorizationCode,
        .logInWithUsername:
            return "/oauth2/token"

        case
        .signupUser:
            return "/users"

        case
        .getCurrentlyAuthenticatedUser:
            return "/users/me"

            //        case
            //        .updateAuthenticatedUser,
            //        .updateAuthenticatedUserPhoto:
            //            return "users/me"
            //
        case
        .getUser(let userID):
            return "/users/\(userID)"

        case
        .sendPasswordReset:
            return "/users/password/reset"
            //
            //        case
            //        .updateAuthenticatedUserLocation:
            //            return "users/me/location/update"
            //
        case
        .banUser(let userID, let accountID, _):
            return "/users/\(userID)/ban/\(accountID)"

        case
        .getPostedContentFromUser(let userID, let contentListType, _):
            return "/users/\(userID)/content/\(contentListType)"
            
        default :
            return ""
        }
    }

    // Request type
    public var method: Moya.Method {
        switch self {

        case
        .loginWithAuthorizationCode,
        .logInWithUsername,

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
        .loginWithAuthorizationCode:
            return "AAA".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .logInWithUsername:
            return "AAA".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .signupUser:
            return "AAA".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .getCurrentlyAuthenticatedUser:
            return "BBB".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .getUser:
            return "BBB".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .updateAuthenticatedUserWithParameters:
            return "CCC".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .banUser:
            return "DDD".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .getPostedContentFromUser:
            return "EEE".dataUsingEncoding(NSUTF8StringEncoding)!

        case
        .sendPasswordReset:
            return "FFF".dataUsingEncoding(NSUTF8StringEncoding)!

        default:
            return "XXX".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }

    // Parameters
    public var parameters: [String: AnyObject] {
        switch self {

        case .loginWithAuthorizationCode(let authorizationCode):
            return ["code" : authorizationCode,
                "expand" : true,
                "include_admin_accounts" : true,
                "grant_type" : "authorization_code"]

        case .logInWithUsername(let username,
            let password):
            return ["username" : username,
                "password" : password,
                "expand" : "user",
                "include_admin_accounts" : true,
                "grant_type" : "password"]

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

        case .banUser(_, _, let reason):
            return ["reason" : reason]

        case .sendPasswordReset(let email):
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

struct Provider {
    private static var endpointsClosure = { (target: CocoaBlocAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<CocoaBlocAPI> in

        var endpoint: Endpoint<CocoaBlocAPI> = Endpoint<CocoaBlocAPI>(URL: url(target), sampleResponse: .Success(200, {target.sampleData}), method: method, parameters: parameters)

        switch target {

        case .loginWithAuthorizationCode,
            .logInWithUsername:

            return endpoint.endpointByAddingParameters(["client_secret" : "blahblahblah"])

        default:
            return endpoint
        }
    }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

//func endpointResolver() -> ((endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest)) {
//    return { (endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest) in
//        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
//        return request
//    }
//}

//func stubbedResponse(filename: String) -> NSData! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = NSBundle(forClass: TestClass.self)
//    let path = bundle.pathForResource(filename, ofType: "json")
//    return NSData(contentsOfFile: path!)
//}

