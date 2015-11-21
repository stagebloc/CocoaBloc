//
//  API+SampleData.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

private enum StubFile: String {
    case User           = "user"
    case Account        = "account"
    case Content        = "content"
    case Photo          = "photo"
    case Video          = "video"
    case Blog           = "blog"
    case Status         = "status"
    case Audio          = "audio"
    case Fanclub        = "fanclub"
    case Comment        = "comment"
    case PasswordReset  = "password_reset"
}

extension API {

    public var sampleData: NSData {
        switch self {

        case
        .LogInWithUsername,
        .LoginWithAuthorizationCode,
        .SignUp,
        .GetCurrentlyAuthenticatedUser,
        .GetUser,
        .BanUser:
            return stubbedResponse(.User)

        case
        .GetAccount,
        .CreateAccount:
            return stubbedResponse(.Account)

        case
        .GetContent:
            return stubbedResponse(.Content)

        case
        .SendPasswordReset:
            return stubbedResponse(.PasswordReset)

        // TODO: Remove default case when all endpoints implemented
        default:
            return "".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

private func stubbedResponse(stubFile: StubFile) -> NSData! {
    @objc class TestClass: NSObject { }
    let bundle = NSBundle(forClass: TestClass.self)
    return NSData(contentsOfFile: bundle.pathForResource(stubFile.rawValue, ofType: "json")!)
}
