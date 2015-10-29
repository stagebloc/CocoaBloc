//
//  API+Method.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveMoya

extension API  {

    public var method: Moya.Method {
        switch self {

        case

        .LoginWithAuthorizationCode,
        .LogInWithUsername,

        // User
        .SignupUser,
        .BanUser,
        .SendPasswordReset,

        .UpdateAuthenticatedUserWithParameters,
        //        .updateAuthenticatedUserPhoto,
        //        .updateAuthenticatedUserLocation:

        // Account
        .CreateAccount,
        .CreateAccountWithPhoto,
        .UpdateAccount,
        .UpdateAccountImage,
        .FollowAccount,

        // Content
        .FlagContent,
        .FlagContentWithIdentifier,
        .PostStatus,
        .PostStatusWithLocation,
        .PostBlog,
        .UploadPhoto,
        .UploadVideoAtPath,
        .UploadVideoWithData,
        .TrackVideoEvent,
        .UploadAudioData,

        // Comment
        .PostCommentOnContent,
        .PostCommentInReplyToComment,
        .FlagComment,
        .FlagCommentWithIdentifier,

        // Fanclub
        .CreateFanClub,

        // Store
        .GetShippingRatesAndTax,
        .PurchaseItems,
        .AddPaymentForSplitPurchase,
        .RequestStripeAuthorization,

        .SetPushTokenForAuthenticatedUser:
            return .POST

        case
        // User
        .GetCurrentlyAuthenticatedUser,
        .GetUser,
        .GetPostedContentFromUser,

        // Account
        .GetAccount,
        .GetAccountsForUser,
        .GetAuthenticatedUserAccounts,
        .GetActivityStreamForAccount,
        .GetFollowingUsersForAccount,
        .GetChildrenAccountsForAccount,

        // Content
        .GetUsersWhoLikeContent,
        .GetContentWithIdentifier,
        .GetPhoto,
        .GetAudioTrackWithID,

        // Comment
        .GetComment,
        .GetCommentsForContent,
        .GetRepliesToComment,


        // Fanclub
        .GetContentFromFanClub,
        .GetContentFromFollowedFanClubs,
        .GetFollowedFanClubs,
        .GetRecentFanClubs,
        .GetFeaturedFanClubs,
        .GetFanClub,
        .GetFanClubDashboard,

        // Store
        .GetStoreItemsForAccount,
        .GetStoreItemWithID,
        .GetStoreDashboard,

        .GetNotifications:
            return .GET
            
        case
        // Account
        .UnfollowAccount,

        // Content
        .UnlikeContent,
        .DeleteContent,

        // Comment
        .DeleteComment:
            return .DELETE
            
        default:
            return .GET
        }
    }
}



