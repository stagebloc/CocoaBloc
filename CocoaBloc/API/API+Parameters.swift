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
            
        case .GetCurrentlyAuthenticatedUser:
            return nil
        
        case .BanUser:
            return nil
            
        case .SendPasswordReset(let email):
            return ["email" : email]
            
        case let .UpdateAuthenticatedUserLocation(latitude, longitude):
            return ["latitude" : latitude, "longitude" : longitude]
            
        case .GetUser:
            return nil
            
        case let .UpdateAuthenticatedUser(bio, birthday, email, username, name, gender, color):
            return [
                "bio"       : bio,
                "birthday"  : birthday,
                "email"     : email,
                "name"      : name,
                "username"  : username,
                "gender"    : gender?.rawValue,
                "color"     : color?.rawValue
            ].filterNil()

        case let .SignUp(email, name, password, bio, birthday, gender, sourceAccountID):
            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
            df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"

            return [
                "email"     : email,
                "name"      : name,
                "bio"       : bio,
                "password"  : password,
                "birthday"  : df.stringFromDate(birthday),
                "gender"    : gender.rawValue,
                "source_account_id" : sourceAccountID
            ].filterNil()
            
        case .GetPostedContentFromUser:
            return nil
            
        case let .CreateAccount(name, description, url, type, color):
            return [
                "name"          : name,
                "description"   : description,
                "stagebloc_url" : url,
                "type"          : type.rawValue,
                "color"         : color.rawValue
            ]
            
        case let .UpdateAccount(_, name, description, url, type, color):
            return [
                "name"          : name,
                "description"   : description,
                "stagebloc_url" : url,
                "type"          : type.rawValue,
                "color"         : color.rawValue
            ]
            
        case .UpdateAccountImage:
            return nil
            
        case
        .GetAccountsForUser,
        .GetAccount,
        .GetActivityStreamForAccount,
        .GetFollowingUsersForAccount,
        .GetChildrenAccountsForAccount:
            return nil
            
        case .FollowAccount, .UnfollowAccount:
            return nil
            
        case .GetAuthenticatedUserAccounts:
            return nil
            
        case .LikeContent, .UnlikeContent, .DeleteContent, .GetUsersWhoLikeContent, .GetContent:
            return nil
            
        case let .FlagContent(_, type, reason):
            return ["type": type.rawValue, "reason": reason]
            
        case let .PostStatus(text, _, fanContent, location):
            return [
                "text"          : text,
                "fan_content"   : fanContent,
                "latitude"      : location?.latitude,
                "longitude"     : location?.longitude
            ].filterNil()
            
        case let .PostBlog(title, body, _):
            return ["title": title, "body": body]

        case let .UploadPhoto(title, description, _, exclusive, fanContent):
            return [
                "title"         : title,
                "description"   : description,
                "exclusive"     : exclusive,
                "fan_content"   : fanContent
            ]
            
        case let .UploadVideo(title, description, _, exclusive, fanContent):
            return [
                "title"         : title,
                "description"   : description,
                "exclusive"     : exclusive,
                "fan_content"   : fanContent
            ]
            
        case let .TrackVideoEvent(event, _, _):
            return ["event": event.rawValue]
            
        case let .UploadAudio(title, _):
            return ["title": title]
            
        case
        .GetPlaylist,
        .GetPlaylistsForAccount,
        .GetCommentsForContent, 
        .GetRepliesToComment,
        .DeleteComment:
            return nil
            
        case let .PostCommentOnContent(text, _):
            return ["text": text]
            
        case let .PostReplyToComment(text, _):
            return ["text": text]
            
        case .GetComment:
            return nil
            
        case let .FlagComment(_, _, _, type, reason):
            return ["type": type.rawValue, "reason": reason]
            
        case .GetFanClubDashboard:
            return nil
            
        case let .CreateFanClub(_, title, description, tierInfo):
            return [
                "title"         : title,
                "description"   : description,
                "tier_info"     : tierInfo
            ]
            
        case
        .GetFanClubs,
        .GetFanClubFans,
        .GetContentFromFollowedFanClubs,
        .GetFanClub,
        .GetFanClubContent,
        .GetStoreDashboard,
        .GetOrders:
            return nil
            
        case let .SetOrderShipped(_, _, trackingNumber, carrier):
            return ["tracking_number": trackingNumber, "carrier": carrier]
            
        case .GetStoreItemsForAccount, .GetStoreItem, .GetShippingRatesAndTax:
            return nil
            
        case let .PurchaseItems(
            items,
            amount,
            purchaseToken,
            address,
            shippingDetails,
            totals,
            notes,
            email,
            cash,
            _):
            return [
                "cash"      : cash,
                "email"     : email,
                "token"     : purchaseToken,
                "cart"      : items,
                "shipping"  : shippingDetails,
                "address"   : address,
                "notes"     : notes,
                "totals"    : totals,
                "amount"    : amount,
            ]
            
        case let .AddPaymentForSplitPurchase(orderID, amount, token, _):
            return [
                "orderId"   : orderID,
                "amount"    : amount,
                "token"     : token
            ]
            
        case let .RequestStripeAuthorization(requestToken, _):
            return ["token": requestToken];
            
        case let .SetPushTokenForAuthenticatedUser(token):
            return ["token": token]
            
        case .GetNotifications, .GetEvents, .GetCoupon:
            return nil
            
        case let .ValidateCoupon(_, couponCode):
            return ["code": couponCode]
            
        }
    }
}

private extension SequenceType where Generator.Element == (String, AnyObject?) {
    func filterNil() -> [String:AnyObject] {
        var ret = [String:AnyObject]()
        for tuple in self where tuple.1 != nil {
            ret[tuple.0] = tuple.1!
        }
        return ret
    }
}
