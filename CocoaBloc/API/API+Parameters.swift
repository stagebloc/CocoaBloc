//
//  API+Parameters.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension API {

    // Endpoint parameter declarations

    public var parameters: [String: AnyObject]? {
        switch self {
            
        case let .Expanded(target, expansions):
            precondition(expansions.count != 0, "Tried to expand a target with no expansion types")
            return (target.parameters ?? [:]).map { $0 + ["expand": expansions.map { $0.rawValue }.joinWithSeparator(",")] }
            
        case let .Parameterized(target, parameters):
            return (target.parameters ?? [:]).map { $0 + parameters }

        case .LoginWithAuthorizationCode(let authorizationCode):
            return [
                "code"          : authorizationCode,
                "grant_type"    : "authorization_code"
            ]

        case .LogInWithUsername(let username, let password):
            return [
                "username"      : username,
                "password"      : password,
                "grant_type"    : "password",
                "expand"        : "user"
            ]

        case .SignUp(
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
                "gender"    : gender.rawValue,
                "source_account_id" : sourceAccountID
            ]

        case .BanUser(_, _, let reason):
            return ["reason" : reason]

        case .SendPasswordReset(let email):
            return ["email" : email]

        case .GetAccountsForUser(let userIdentifier, let includingAdminAccounts, let followingAccounts):
            return [
                "user_id"   : userIdentifier,
                "admin"     : includingAdminAccounts,
                "following" : followingAccounts
            ]

        case .CreateAccount(let name, let url, let type, let color):
            return [
                "name"          : name,
                "stagebloc_url" : url,
                "type"          : type.rawValue,
                "color"         : color.rawValue
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
