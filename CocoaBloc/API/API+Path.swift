//
//  API+Path.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveMoya

extension API {

    // URL path declarations 

    public var path: String {
        switch self {
            
        case .Expanded(let target, _):
            return target.path
            
        case .Parameterized(let target, _):
            return target.path

    // Auth
        case
        .LoginWithAuthorizationCode,
        .LogInWithUsername:
            return "/oauth2/token"
            
        case .GetCurrentlyAuthenticatedUser:
            return "/users/me"

        case .BanUser(let userID, let accountID, _):
            return "/users/\(userID)/ban/\(accountID)"

        case .SendPasswordReset:
            return "/users/password/reset"

        case .UpdateAuthenticatedUserLocation:
            return "users/me/location/update"
            
        case .GetUser(let userID):
            return "/users/\(userID)"

        case .UpdateAuthenticatedUser:
            return "users/me"
 
        case .SignUp:
            return "/users"
            
        case .GetPostedContentFromUser(let userID, let content):
            return "/users/\(userID)/content/\(content.rawValue)"
            
        case .CreateAccount:
            return "account"

        case .UpdateAccount(let accountID, _, _, _, _, _):
            return "/account/\(accountID)"
            
        case .UpdateAccountImage(let accountID):
            return "/account/\(accountID)"

        case
        .GetAccountsForUser,
        .GetAuthenticatedUserAccounts:
            return "accounts"

        case .GetAccount(let accountID):
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
            
        case .LikeContent(let content):
            return "/account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)/like"
            
        case .UnlikeContent(let content):
            return "/account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)/like"
            
        case .DeleteContent(let content):
            return "/account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)"

        case .GetUsersWhoLikeContent(let content):
            return "account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)/likers"
            
        case .GetContent(let content):
            return "account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)"
            
        case .FlagContent(let content, let contentType, _):
            return "/account/\(content.accountID)/\(contentType)/\(content.contentID)/flag"
            
        case .PostStatus(_, let accountID, _, _):
            return "/account/\(accountID)/status"
            
        case .PostBlog(_, _, let accountID):
            return "/account/\(accountID)/blog"

        case .UploadPhoto(_, _, let accountID, _, _):
            return "account/\(accountID)/photo"
            
            // Videos
        case .UploadVideo(_, _, let accountID, _, _):
            return "account\(accountID)/video"
            
        case let .TrackVideoEvent(_, videoID, accountID):
            return "account/\(accountID)/video/\(videoID)/stats"
            
        case let .UploadAudio(_, accountID):
            return "account/\(accountID)/audio"

        case let .GetPlaylist(playlistID, accountID):
            return "account/\(accountID)/audio/playlist/\(playlistID)"
            
        case .GetPlaylistsForAccount(let accountID):
            return "account/\(accountID)/audio/playlists"
            
        case .GetCommentsForContent(let content):
            return "account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)/comments"
            
        case let .GetRepliesToComment(commentID, accountID, contentType):
            return "account/\(accountID)/\(contentType.rawValue)/comment/\(commentID)"
            
        case let .DeleteComment(commentID, accountID, contentType):
            return "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)"
            
        case let .PostCommentOnContent(_, content):
            return "account/\(content.accountID)/\(content.contentType.rawValue)/\(content.contentID)/comment"
            
            
        ///////////////
        /////////////// warning: fix this
        case let .PostReplyToComment(_, content):
            return ""
            
        case let .GetComment(commentID, content):
            return "account\(content.accountID)/\(content.contentType.rawValue)/comment/\(commentID)"
            
        case let .FlagComment(commentID, contentType, accountID, _, _):
            return "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)/flag"
            
        case .GetFanClubDashboard(let accountID):
            return "account\(accountID)/fanclub/dashboard"
            
        case let .CreateFanClub(accountID, _, _, _):
            return "account/\(accountID)/fanclub/"
            
        case let .GetFanClubs(accountID, type):
            return "account/\(accountID)/fanclubs/\(type.rawValue)"
            
        case .GetFanClubFans(let accountID):
            return "account/\(accountID)/fans"
            
        case .GetContentFromFollowedFanClubs:
            return "account/fanclubs/following/content"
            
        case .GetFanClub(let accountID):
            return "account/\(accountID)/fanclub"
            
        case .GetFanClubContent(let accountID):
            return "account/\(accountID)/fanclub/content"
            
        case .GetStoreDashboard(let accountID):
            return "account/\(accountID)/store/dashboard"
            
        case .GetOrders(let accountID):
            return "account/\(accountID)/store/orders"
            
        case let .SetOrderShipped(orderID, accountID, _, _):
            return "account/\(accountID)/store/orders/\(orderID)"
            
        case .GetStoreItemsForAccount(let accountID):
            return "account/\(accountID)/store/items"
            
        case let .GetStoreItem(storeItemID, accountID):
            return "account/\(accountID)/store/items/\(storeItemID)"
            
        case let .GetShippingRatesAndTax(accountID, _, _):
            return "account/\(accountID)/store/cart/totals"
            
        case let .PurchaseItems(_, _, _, _, _, _, _, _, _, accountID):
            return "account/\(accountID)/store/purchase"
            
        case let .AddPaymentForSplitPurchase(_, _, _, accountID):
            return "account/\(accountID)/store/purchase/split"
            
        case let .RequestStripeAuthorization(_, accountID):
            return "account/\(accountID)/store/stripe"
            
        case .SetPushTokenForAuthenticatedUser:
            return "application/push/token"
            
        case .GetNotifications:
            return "users/me/notifications"
            
        case .GetEvents(let accountID):
            return "account/\(accountID)/events"
            
        case let .GetCoupon(accountID, couponID):
            return "account/\(accountID)/store/coupon/\(couponID)"
            
        case let .ValidateCoupon(accountID, _):
            return "account/\(accountID)/store/coupon/code/validate"
        
        }
    }
}

