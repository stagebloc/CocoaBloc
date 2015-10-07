//
//  CocoaBlocAPI+Path.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveMoya

extension CocoaBlocAPI {

    // URL path declarations 

    public var path: String {
        switch self {

    // Auth
        case
        .loginWithAuthorizationCode,
        .logInWithUsername:
            return "/oauth2/token"

    // User
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

    // Account
        case
        .getAccount(let accountID):
            return "/account/\(accountID)"

        case
        .getAccountsForUser,
        .getAuthenticatedUserAccounts:
            return "accounts"

        case
        .createAccount:
            return "account"

        case
        .updateAccount(let accountID, _, _, _, _, _):
            return "/account/\(accountID)"

        case
        .updateAccountImage(let accountID, _, _):
            return "/account/\(accountID)"

        case
        .getActivityStreamForAccount(let accountID, _):
            return "/account/\(accountID)/content"

        case
        .getFollowingUsersForAccount(let accountID, _):
            return "/account/\(accountID)/fans"

        case
        .getChildrenAccountsForAccount(let accountID, let type):
            return "account/\(accountID)/children/\(type)"

        case
        .followAccount(let accountID):
            return "account/\(accountID)/follow"

        case
        .unfollowAccount(let accountID):
            return "account/\(accountID)/follow"

        default:
            return ""
        }
    }
}

