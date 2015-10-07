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
        .followAccount:
            return .POST


        case .getCurrentlyAuthenticatedUser,
        .getUser,
        .getPostedContentFromUser,

        .getAccount,
        .getAccountsForUser,
        .getAuthenticatedUserAccounts,
        .getActivityStreamForAccount,
        .getFollowingUsersForAccount,
        .getChildrenAccountsForAccount:
            return .GET

        case .unfollowAccount:
            return .DELETE

        default:
            return .GET
        }
    }
}



