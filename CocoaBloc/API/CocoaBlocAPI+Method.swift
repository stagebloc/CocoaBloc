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

    public var method: Moya.Method {
        switch self {

        case

        .loginWithAuthorizationCode,
        .logInWithUsername,

        // User
        .signupUser,
        .banUser,
        .sendPasswordReset,

        .updateAuthenticatedUserWithParameters,
        //        .updateAuthenticatedUserPhoto,
        //        .updateAuthenticatedUserLocation:

        // Account
        .createAccount,
        .createAccountWithPhoto,
        .updateAccount,
        .updateAccountImage,
        .followAccount,

        // Content
        .flagContent,
        .flagContentWithIdentifier,
        .postStatus,
        .postStatusWithLocation,
        .postBlog,
        .uploadPhoto,
        .uploadVideoAtPath,
        .uploadVideoWithData,
        .trackVideoEvent,
        .uploadAudioData,

        // Comment
        .postCommentOnContent,
        .postCommentInReplyToComment,
        .flagComment,
        .flagCommentWithIdentifier,

        // Fanclub
        .createFanClub,

        // Store
        .getShippingRatesAndTax,
        .purchaseItems,
        .addPaymentForSplitPurchase,
        .requestStripeAuthorization,

        .setPushTokenForAuthenticatedUser:
            return .POST

        case
        // User
        .getCurrentlyAuthenticatedUser,
        .getUser,
        .getPostedContentFromUser,

        // Account
        .getAccount,
        .getAccountsForUser,
        .getAuthenticatedUserAccounts,
        .getActivityStreamForAccount,
        .getFollowingUsersForAccount,
        .getChildrenAccountsForAccount,

        // Content
        .getUsersWhoLikeContent,
        .getContentWithIdentifier,
        .getPhoto,
        .getAudioTrackWithID,

        // Comment
        .getComment,
        .getCommentsForContent,
        .getRepliesToComment,


        // Fanclub
        .getContentFromFanClub,
        .getContentFromFollowedFanClubs,
        .getFollowedFanClubs,
        .getRecentFanClubs,
        .getFeaturedFanClubs,
        .getFanClub,
        .getFanClubDashboard,

        // Store
        .getStoreItemsForAccount,
        .getStoreItemWithID,
        .getStoreDashboard,

        .getNotifications:
            return .GET
            
        case
        // Account
        .unfollowAccount,

        // Content
        .unlikeContent,
        .deleteContent,

        // Comment
        .deleteComment:
            return .DELETE
            
        default:
            return .GET
        }
    }
}



