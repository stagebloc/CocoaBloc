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

enum CocoaBlocAPI : MoyaTarget {

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


    //    /*!
    //    Update user information methods
    //    */
    //    case updateAuthenticatedUserWithPhoto(parameters : NSDictionary,
    //                                           photoData : NSData,
    //                                      progressSignal : RACSignal)
    //    case updateAuthenticatedUserPhoto(photoData : NSData, progressSignal : RACSignal)
    //
    //    case updateAuthenticatedUserLocation(coordinates, CLLocationCoordinate2D)
    //


    var baseURL: NSURL { return NSURL(string: "https://api.stagebloc.com/v1")! }
}

func stubbedResponse(filename: String) -> NSData! {
    @objc class TestClass: NSObject { }

    let bundle = NSBundle(forClass: TestClass.self)
    let path = bundle.pathForResource(filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}

func endpointResolver() -> ((endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest)) {
    return { (endpoint: Endpoint<CocoaBlocAPI>) -> (NSURLRequest) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.HTTPShouldHandleCookies = false
        return request
    }
}

func x() {
    let client = MoyaProvider<CocoaBlocAPI>()
}

//struct Provider {
//}
