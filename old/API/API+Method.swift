//
//  API+Method.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Alamofire

extension API  {

    public var method: Alamofire.Method {
        switch self {
            
        case .Expanded(let target, _):
            return target.method
            
        case .Parameterized(let target, _):
            return target.method

        case

        .LoginWithAuthorizationCode,
        .LogInWithUsername,

        // User
        .BanUser,
        .SignUp,
        .UpdateAuthenticatedUser,
        .UpdateAuthenticatedUserLocation,
        .SendPasswordReset,

        // Account
        .CreateAccount,
        .UpdateAccount,
        .UpdateAccountImage,
        .FollowAccount,

        // Content
        .LikeContent,
        .UnlikeContent,
        .FlagContent,
        .PostStatus,
        .PostBlog,
        .UploadPhoto,
        .UploadVideo,
        .TrackVideoEvent,
        .UploadAudio,

        // Comment
        .PostCommentOnContent,
        .PostReplyToComment,
        .FlagComment,

        // Fan Club
        .CreateFanClub,

        // Store
        .SetOrderShipped,
        .PurchaseItems,
        .AddPaymentForSplitPurchase,
        .RequestStripeAuthorization,
        
        .ValidateCoupon,

        .SetPushTokenForAuthenticatedUser:
            return .POST

        case
        // User
        .GetUser,
        .GetPostedContentFromUser,
        .GetCurrentlyAuthenticatedUser,

        // Account
        .GetAccountsForUser,
        .GetAccount,
        .GetActivityStreamForAccount,
        .GetFollowingUsersForAccount,
        .GetChildrenAccountsForAccount,
        .GetAuthenticatedUserAccounts,

        // Content
        .GetUsersWhoLikeContent,
        .GetContent,
        .GetPlaylist,
        .GetPlaylistsForAccount,

        // Comment
        .GetCommentsForContent,
        .GetRepliesToComment,
        .GetComment,
        
        // Fan Club
        .GetFanClubDashboard,
        .GetFanClubs,
        .GetFanClubFans,
        .GetContentFromFollowedFanClubs,
        .GetFanClub,
        .GetFanClubContent,
        
        // Store
        .GetStoreDashboard,
        .GetOrders,
        .GetStoreItemsForAccount,
        .GetStoreItem,
        .GetShippingRatesAndTax,

        .GetEvents,
        .GetCoupon,
        .GetNotifications:
            return .GET
            
        case
        .UnfollowAccount,
        .DeleteContent,
        .DeleteComment:
            return .DELETE
            
        }
    }
}



