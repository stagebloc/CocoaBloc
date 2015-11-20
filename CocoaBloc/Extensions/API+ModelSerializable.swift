//
//  API+ModelSerializable.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

extension API: ModelSerializable {
    public var modelType: MTLModel.Type? {
        switch self {
            
        case .Expanded(let target, _):
            return target.modelType
            
        case .Parameterized(let target, _):
            return target.modelType
            
        case
        .LoginWithAuthorizationCode,
        .LogInWithUsername,
        .GetCurrentlyAuthenticatedUser:
            return SBUser.self
        
        case .BanUser, .SendPasswordReset:
            return nil
            
        case
        .UpdateAuthenticatedUserLocation,
        .GetUser,
        .UpdateAuthenticatedUser,
        .SignUp:
            return SBUser.self

        case .GetPostedContentFromUser:
            return SBContent.self
            
        case
        .CreateAccount,
        .UpdateAccount,
        .UpdateAccountImage,
        .GetAccountsForUser,
        .GetAccount:
            return SBAccount.self
         
        case .GetActivityStreamForAccount:
            return SBContent.self
            
        case .GetFollowingUsersForAccount:
            return SBUser.self
            
        case .GetChildrenAccountsForAccount:
            return SBAccount.self
            
        case
        .FollowAccount,
        .UnfollowAccount,
        .GetAuthenticatedUserAccounts:
            return SBAccount.self
            
        case
        .LikeContent,
        .UnlikeContent,
        .DeleteContent:
            return SBContent.self
            
        case .GetUsersWhoLikeContent:
            return SBUser.self
            
        case .GetContent:
            return SBContent.self
            
        case .FlagContent:
            return SBContent.self
            
        case .PostStatus:
            return SBStatus.self
            
        case .PostBlog:
            return SBBlog.self
            
        case .UploadPhoto:
            return SBPhoto.self
            
        case .UploadVideo:
            return SBVideo.self
            
        case .TrackVideoEvent:
            return SBVideo.self
            
        case .UploadAudio:
            return SBAudio.self
            
        case .GetPlaylist, .GetPlaylistsForAccount:
            return nil
            
        case
        .GetCommentsForContent,
        .GetRepliesToComment,
        .DeleteComment,
        .PostCommentOnContent,
        .PostReplyToComment,
        .GetComment,
        .FlagComment:
            return SBComment.self
            
        case .GetFanClubDashboard:
            return SBFanClubDashboard.self
            
        case .CreateFanClub, .GetFanClubs:
            return SBFanClub.self
            
        case .GetFanClubFans:
            return SBUser.self
            
        case .GetContentFromFollowedFanClubs:
            return SBContent.self
            
        case .GetFanClub:
            return SBFanClub.self
            
        case .GetFanClubContent:
            return SBContent.self
            
        case .GetStoreDashboard:
            return SBStoreDashboard.self
            
        case .GetOrders, .SetOrderShipped:
            return SBOrder.self
            
        case .GetStoreItemsForAccount, .GetStoreItem:
            return SBStoreItem.self

        case .GetShippingRatesAndTax:
            return SBShippingRateSet.self
            
        case .PurchaseItems, .AddPaymentForSplitPurchase:
            return SBOrder.self
            
        case .RequestStripeAuthorization:
            return SBAccount.self
            
        case .SetPushTokenForAuthenticatedUser:
            return nil
            
        case .GetNotifications:
            return SBNotification.self
            
        case .GetEvents:
            return nil
            
        case .GetCoupon:
            return nil
            
        case .ValidateCoupon:
            return nil
        }
    }
}