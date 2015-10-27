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
        .LoginWithAuthorizationCode,
        .LogInWithUsername:
            return "/oauth2/token"

    // User
        case .SignupUser:
            return "/users"

        case .GetCurrentlyAuthenticatedUser:
            return "/users/me"

            //        case
            //        .updateAuthenticatedUser,
            //        .updateAuthenticatedUserPhoto:
            //            return "users/me"
            //
        case .GetUser(let userID):
            return "/users/\(userID)"

        case .SendPasswordReset:
            return "/users/password/reset"
            //
            //        case
            //        .updateAuthenticatedUserLocation:
            //            return "users/me/location/update"
            //
        case .BanUser(let userID, let accountID, _):
            return "/users/\(userID)/ban/\(accountID)"

        case .GetPostedContentFromUser(let userID, let contentListType, _):
            return "/users/\(userID)/content/\(contentListType)"

    // Account
        case .GetAccount(let accountID):
            return "/account/\(accountID)"

        case
        .GetAccountsForUser,
        .GetAuthenticatedUserAccounts:
            return "accounts"

        case .CreateAccount:
            return "account"

        case .UpdateAccount(let accountID, _, _, _, _, _):
            return "/account/\(accountID)"

        case .UpdateAccountImage(let accountID, _, _):
            return "/account/\(accountID)"

        case .GetActivityStreamForAccount(let accountID):
            return "/account/\(accountID)/content"

        case .GetFollowingUsersForAccount(let accountID):
            return "/account/\(accountID)/fans"

        case .GetChildrenAccountsForAccount(let accountID, let type):
            return "/account/\(accountID)/children/\(type)"

        case .FollowAccount(let accountID):
            return "/account/\(accountID)/follow"

        case .UnfollowAccount(let accountID):
            return "/account/\(accountID)/follow"

    // Content
        case .LikeContent(let content):
            return "/account/\(content.accountID)/\(content.classForCoder.URLPathContentType())/\(content.identifier)/like"

        case .UnlikeContent(let content):
            return "/account/\(content.accountID)/\(content.classForCoder.URLPathContentType())/\(content.identifier)/like"

        case .DeleteContent(let content):
            return "/account/\(content.accountID)/\(content.classForCoder.URLPathContentType())/\(content.identifier)"

        case .GetUsersWhoLikeContent(let content):
            return "/account/\(content.accountID)/\(content.classForCoder.URLPathContentType())/\(content.identifier)/likers"

        case .GetContentWithIdentifier(let contentID, let contentType, let accountID):
            return "/account/\(accountID)/\(contentType)/\(contentID)"

        case .FlagContent(let content, let contentType, _):
            return "/account/\(content.account.identifier)/\(contentType)/\(content.identifier)/flag"

        case .FlagContentWithIdentifier(let contentIdentifier, let contentType, let accountID, _, _):
            return "/account/\(accountID)/\(contentType)/\(contentIdentifier)/flag"

        case .PostStatus(_, let accountID, _):
            return "/account/\(accountID)/status"

        case .PostStatusWithLocation(_, let accountID, _, _, _):
            return "/account/\(accountID)/status"

        case .PostBlog(_, _, let accountID):
            return "/account/\(accountID)/blog"

        default:
            return ""
        }
    }
}

