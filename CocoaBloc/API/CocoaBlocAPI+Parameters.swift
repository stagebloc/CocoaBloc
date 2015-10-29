//
//  CocoaBlocAPI+Parameters.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension CocoaBlocAPI {

    // Endpoint parameter declarations

    public var parameters: [String: AnyObject]? {
        switch self {

        case .LoginWithAuthorizationCode(let authorizationCode):
            return [
                "code" : authorizationCode,
                "grant_type" : "authorization_code"
            ]

        case .LogInWithUsername(let username, let password):
            return [
                "username"      : username,
                "password"      : password,
                "grant_type"    : "password",
                "expand"        : "user"
            ]

        case .SignupUser(
            let email,
            let name,
            let password,
            let birthday,
            let gender,
            let sourceAccountID):

            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"

            return [
                "email"     : email,
                "name"      : name,
                "password"  : password,
                "birthday"  : df.stringFromDate(birthday),
                "gender"    : gender,
                "source_account_id" : sourceAccountID
            ]

        case .BanUser(_, _, let reason):
            return ["reason" : reason]

        case .SendPasswordReset(let email):
            return ["email" : email]

        case .GetAccountsForUser(let userIdentifier, let includingAdminAccounts, let followingAccounts):
            return [
                "user_id" : userIdentifier,
                "admin" : includingAdminAccounts,
                "following" : followingAccounts
            ]

        case .CreateAccount(let name, let url, let type, let color):
            return [
                "name"          : name,
                "stagebloc_url" : url,
                "type"          : type,
                "color"         : color
            ]

        default:
            /*! Endpoints w/o parameters
            .getCurrentlyAuthenticatedUser
            .getUser
            .getAccount
            */
            return [:]
        }
    }
}
