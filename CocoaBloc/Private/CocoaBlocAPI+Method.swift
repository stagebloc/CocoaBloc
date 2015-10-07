//
//  CocoaBlocAPI+Method.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveMoya

extension CocoaBlocAPI  {

    // HTTP method declarations

    public var method: Moya.Method {
        switch self {

        case .loginWithAuthorizationCode,
        .logInWithUsername,

        .signupUser,
        .banUser,
        .sendPasswordReset,
        //        .updateAuthenticatedUser,
        //        .updateAuthenticatedUserPhoto,
        //        .updateAuthenticatedUserLocation:

        .createAccount,
        .updateAccount,
        .updateAccountImage,
        .followAccount,

        .flagContent,
        .flagContentWithIdentifier,
        .postStatus,
        .postStatusWithLocation,
        .postBlog:
            return .POST

        case .getCurrentlyAuthenticatedUser,
        .getUser,
        .getPostedContentFromUser,

        .getAccount,
        .getAccountsForUser,
        .getAuthenticatedUserAccounts,
        .getActivityStreamForAccount,
        .getFollowingUsersForAccount,
        .getChildrenAccountsForAccount,

        .getUsersWhoLikeContent,
        .getContentWithIdentifier:
            return .GET
            
        case .unfollowAccount,

        .unlikeContent,
        .deleteContent:
            return .DELETE
            
        default:
            return .GET
        }
    }
}



