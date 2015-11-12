//
//  API.swift
//  CocoaBloc
//
//  Created by David Warner on 10/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveMoya

/// An enumeration representing a StageBloc API target
public enum API: MoyaTarget {
    
    /// These are types of values that the API will expand from identifiers to JSON objects.
    /// NOTE: The raw values of these cases correspond to raw JSON keys
    public enum ExpandableValue: String {
        case Photo      = "photo"
        case Photos     = "photos"
        case Account    = "account"
        case User       = "user"
        case Tags       = "tags"
        case Audio      = "audio"
        case CreatedBy  = "created_by"
        case ModifiedBy = "modified_by"
        case Content    = "content"
    }
    
    /// A special wrapper target to include expansion value types
    indirect case Expanded(target: API, expansions: [ExpandableValue])
    
    /// A special wrapper target to apply additional arbitrary parameters to its request
    indirect case Parameterized(target: API, parameters: [String:AnyObject])

// MARK: Auth endpoints

    /**
    Complete the log in process with an authorization code from StageBloc, usually obtained from SBAuthenticationController.

    - Parameters:
        - authorizationCode: The authorization code.
    */
    case LoginWithAuthorizationCode(authorizationCode: String)

    /**
    Log in a StageBloc user with the given credentials.

    - Parameters:
        - username: The user's username/email address.
        - password: The user's password.
    */
    case LogInWithUsername(username: String, password: String)


// MARK: User endpoints

    public enum Gender: String {
        case Male       = "male"
        case Female     = "female"
        case Cupcake    = "cupcake"
    }
    
    /**
    Sign up a new StageBloc user with the given user information and desired credentials.

    - Parameters:
        - email: The user's email address.
        - name: The user's name.
        - password: The user's password.
        - birthday: The user's birthday.
        - gender: The user's gender.
        - sourceAccountID: The identifier of the account from which user is signing up.
    */
    case SignUp(email: String,
        name: String,
        password: String,
        birthday: NSDate,
        gender: Gender,
        sourceAccountID: Int)

    /**
    Request the currently authenticated user for the SBClient.
    */
    case GetCurrentlyAuthenticatedUser

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - userID: identifier of user to be requested.
    */
    case GetUser(userID: Int)

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - params: NSDictionary containing user information to be updated.
    */
    case UpdateAuthenticatedUserWithParameters(params: [String:AnyObject])

    /**
    Ban user from specified account.

    - Parameters:
        - userID: identifier of user to be banned.
        - accountID: identifier of account from which to ban user.
        - reason: String containing a reason why user is to be banned.
    */
    case BanUser(userID: Int, accountID: Int, reason: String)

    /**
    Request a list of content the user has either submitted or liked.

    - Parameters:
        - userID: identifier of user for whose content to fetch.
        - contentListType: specifies either a list of user-submitted content ('SBUserContentListTypeUpdate')
        or user-liked content ('SBUserContentListTypeLike').
        - parameters: additional parameters.
    */
    case GetPostedContentFromUser(userID: Int, contentListType: String, parameters: [String:AnyObject])

    /**
    Requests password reset to specified email address.

    - Parameters:
        - email: email address to send passoword reset.
    */
    case SendPasswordReset(email: String)

    /**
    Updates user information .
    - Parameters:
        - email: email address to send passoword reset.
    */
//    case updateAuthenticatedUserWithPhoto(parameters : NSDictionary,
//        photoData : NSData,
//        progressSignal : RACSignal)
//
//
//    case updateAuthenticatedUserPhoto(photoData : NSData, progressSignal : RACSignal)
//
//    case updateAuthenticatedUserLocation(coordinates, CLLocationCoordinate2D)


// MARK: Account endpoints


    /**
    Get an account based on an account ID.
    */
    case GetAccount(accountID: Int)

    /**
    Gets all of the accounts associated with the given user identifier, with options to filter admin and following accounts.
    */
    case GetAccountsForUser(userIdentifier: String, includingAdminAccounts: Bool, followingAccounts: Bool)

    
    public enum AccountColor: String {
        case Blue       = "blue"
        case Purple     = "purple"
        case Red        = "red"
        case Orange     = "orange"
        case Grey       = "grey"
        case Green      = "green"
    }
    
    public enum AccountType: String {
        case Music              = "music"
        case FilmAndTV          = "film/tv"
        case Entertainment      = "entertainment"
        case Sports             = "sports"
        case Celebrity          = "celebrity"
        case Comedian           = "comedian"
        case RecordLabel        = "record label"
        case ManagementCompany  = "management company"
        case Personal           = "personal"
        case Developer          = "developer"
        case Photography        = "photography"
        case Cooking            = "food"
        case Business           = "business"
        case Organization       = "organization"
        case Other              = "other"
    }
    /**
    Creates an account.

    - Parameters:
        - name: name of the new account.
        - url: the url which this account can be found.
        - type: type of the account being created.
        - color: one of: purple, red, green, blue, orange, grey.
    */
    case CreateAccount(name: String, url: String, type: String, color: String)

    /**
    Creates an account with a photo.

    - Parameters:
        - name: name of the new account.
        - url: the url which this account can be found.
        - type: type of the account being created.
        - photoData: the profile photo of the account.
        - photoProgressSignal: the photo progress upload signal.
    */
    case CreateAccountWithPhoto(
        name: String,
        url: String,
        type: String,
        photoData: NSData,
        photoProgressSignal: Signal<Float, NSError>)

    /**
    Update an account with one or more new properties. Only admins of the account are allowed to do this

    - Parameters:
        - name: the new account name, or nil.
        - description: description the new account description, or nil.
        - stageBlocURL: the new StageBloc URL path component for the account, or nil.
        - type: type of account (ex. 'Business', 'Cooking', 'Record Label', etc), or nil.
        - color: account color.
    */
    case UpdateAccount(accountID : Int,
        name: String,
        description: String,
        stageBlocURL: String,
        type: String,
        color: String)

    /**
    Update account photo data

    - Parameters:
        - accountID: identifier of the account for which to update photo.
        - photoData: the profile photo of the account.
        - progressSignal: the photo progress upload signal.
    */
    case UpdateAccountImage(accountID: Int, photoData: NSData, progressSignal: Signal<Float, NSError>?)

    /**
    Get an activity stream of recent content for an account.
    */
    case GetActivityStreamForAccount(accountID: Int)

    /**
    Get a list of users following an account.
    */
    case GetFollowingUsersForAccount(accountID: Int)


    /**
    Fetch child accounts for a particular account

    - Parameters:
        - accountID: accountId the ID of the parent account.
        - type: type a specific type of child account to get (optional).
    */
    case GetChildrenAccountsForAccount(accountID: Int, type: String)

    /**
    Follow an account with its associated identifier
    */
    case FollowAccount(accountIdentifier: Int)

    /**
    Unfollow an account with its associated identifier
    */
    case UnfollowAccount(accountIdentifier: Int)

    /**
    Get the currently authenticated user's accounts.
    */
    case GetAuthenticatedUserAccounts

// MARK: Content endpoints

    /**
    Like a piece of content.
    */
    case LikeContent(content: SBContent)

    /**
    Un-like a piece of content.
    */
    case UnlikeContent(content: SBContent)

    /**
    Delete a piece of content.
    */
    case DeleteContent(content: SBContent)

    /**
    Fetch a list of users who like a piece of content.
    */
    case GetUsersWhoLikeContent(content: SBContent)

    /**
    Fetch a content object.

    - Parameters:
        - contentID: identifier for the content.
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to
    */
    case GetContentWithIdentifier(contentID: Int,
        contentType: String,
        accountID: Int)

    /**
    Flag a content object.

    - Parameters:
        - content: content to be flagged.
        - contentType: type of content (i.e. blog, photo, etc).
        - reason: reason for flagging content
    */
    case FlagContent(content: SBContent, contentType: String, reason: String)

    /**
    Flag a content object.

    - Parameters:
        - contentIdentifier: identifier for the content..
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to.
        - type: string of preset values which can be used for reasons why someone flagged a piece of content
        - reason: reason for flagging content
    */
    case FlagContentWithIdentifier(contentIdentifier: Int,
        contentType: String,
        accountID: Int,
        type: String,
        reason: String)

    /**
    Post status to account. Convenience method for posting statuses.

    - Parameters:
        - status: the status to be posted.
        - accountID: identifier of account to which status is to be posted.
        - fanContent: indicates whether status is submitted by a fan of the account.
    */
    case PostStatus(status: String, accountID: Int, fanContent: Bool)

    /**
    Post status to account. Convenience method for posting statuses.

    - Parameters:
        - status: the status to be posted.
        - accountID: identifier of account to which status is to be posted.
        - fanContent: indicates whether status is submitted by a fan of the account.
        - latitude: latitude coordinate of posted status.
        - longitude: longitude coordinate of posted status.
    */
    case PostStatusWithLocation(status: String,
        accountID: Int,
        fanContent: Bool,
        latitude: Int,
        longitude: Int)

    /**
    Post blog to account. Convenience method for posting statuses.

    - Parameters:
        - title: title of blog post.
        - body: body of blog post.
        - accountID: identifier of account to which status is to be posted.
    */
    case PostBlog(title: String, body: String, accountID: Int)

    /**
    Get a photo from an account.

    - Parameters:
        - photoID: identifier of photo to be fetched
        - account: associated account of the photo
    */
    case GetPhoto(photoID: Int, account: SBAccount)

    /**
    Upload a photo directly to the specified account.

    - Parameters:
        - photoID: identifier of photo to be fetched
        - account: associated account of the photo
    */
    case UploadPhoto(data: NSData,
        title: String,
        caption: String,
        accountID: Int,
        exclusive: Bool,
        fanContent: Bool,
        progressSignal : Signal<Float, NSError>)

    /**
    Upload a photo directly to the specified account.

    - Parameters:
        - data: valid video data.
        - fileName: the path or name of the video file. MIME type is derived from this.
        - title: the video's title.
        - caption: the video's caption.
        - accountID: identifier of account associated with video.
        - exclusive: indicates whether video is exclusive content.
        - fanContent: indicates whether video is fan content.
    */
    case UploadVideoWithData(data: NSData,
        fileName: String,
        title: String,
        caption: String,
        accountID: Int,
        exclusive: Bool,
        fanContent: Bool,
        progressSignal : Signal<Float, NSError>)

    /**
    Upload a video directly from disk by providing the absolute path to the video file.

    - Parameters:
        - filePath: the path or name of the video file. MIME type is derived from this.
        - title: the video's title.
        - caption: the video's caption.
        - accountID: identifier of account associated with video.
        - exclusive: indicates whether video is exclusive content.
        - fanContent: indicates whether video is fan content.
    */
    case UploadVideoAtPath(filePath: String,
        title: String,
        caption: String,
        accountID: Int,
        exclusive: Bool,
        fanContent: Bool,
        progressSignal : Signal<Float, NSError>)

    /**
    Track video events.

    - Parameters:
        - event: video event, supported events -> (play, ended, loop).
        - videoID: the video identifier of the associated event.
        - accountID: identifier of account associated with video.
    */
    case TrackVideoEvent(event: String, videoID: Int, accountID: Int)

    /**
    Fetch audio track.

    - Parameters:
        - audioID: audio track identifier.
        - accountID: identifier of account associated with audio track.
    */
    case GetAudioTrackWithID(audioID: Int, accountID: Int)

    /**
    Fetch audio track.

    - Parameters:
        - data: valid audio track data.
        - title: audio track title.
        - fileName: the path or name of the audio track file.
        - account: identifier of account associated with audio track.
    */
    case UploadAudioData(data: NSData,
        title: String,
        fileName: String,
        account: SBAccount,
        progressSignal : Signal<Float, NSError>?)

// MARK: Comment endpoints

    /**
    Fetch comments for a content object.

    - Parameters:
        - content: content object for which to fetch comments.
    */
    case GetCommentsForContent(content: SBContent)

    /**
    Fetch replies (i.e. comments) to a particular comment.

    - Parameters:
        - comment: comment object for which to fetch replies.
    */
    case GetRepliesToComment(comment: SBComment)
    
    /**
    Deletes a comment.
    */
    case DeleteComment(comment: SBComment)

    /**
    Post a comment to a piece of content.
    */
    case PostCommentOnContent(text: String, content: SBContent)

    /**
    Post a comment in reply to another comment.
    */
    case PostCommentInReplyToComment(text: String, comment: SBComment)

    /**
    Fetch a comment for a piece of content from the comment's identifier.
    */
    case GetComment(commentID: Int, content: SBContent)

    /**
    Flag a comment.
    */
    case FlagComment(comment: SBComment, type: String, reason: String)

    case FlagCommentWithIdentifier(commentID: Int,
        contentType: String,
        accountID: Int,
        type: String,
        reason: String)


// MARK: Fanclub endpoints

    /**
    Create the fan club for the given StageBloc account.

    - Parameters:
        - accountID: the parent/fan-club-owning StageBloc account object.
        - title: the title for the fan club.
        - description: the description for the fan club.
        - tierInfo: a dictionary with any of the following tier info keys, or nil.
    */
    case CreateFanClub(accountID: Int, title: String, description: String, tierInfo: [String:AnyObject])

    /**
    Get an array of content associated with a Fan Club.
    */
    case GetContentFromFanClub(accountID: Int)

    /**
    Retrieves the content for fan clubs that the user follows.
    */
    case GetContentFromFollowedFanClubs

    /**
    Retrieves the user's fan club following list.
    */
    case GetFollowedFanClubs

    /**
    Retrieves the user's recent fan clubs list.
    */
    case GetRecentFanClubs

    /**
    Retrieves the user's featured fan clubs list.
    */
    case GetFeaturedFanClubs

    /**
    Retrieves the fan club details for the account.
    */
    case GetFanClub(accountID: Int)

    /**
    Retrieves the fan club dashboard details for the account.
    */
    case GetFanClubDashboard(accountID: Int)

// MARK: Store endpoints

    /**
    Requests tax and shipping information for a given cart and address. Returns RACTuple with first object = SBShippingRateSet and second object = NSDecimalNumber (taxTotal)

    - Parameters:
        - accountID: accountID of account from which items are being purchased.
        - address: SBAddress for which to fetch tax and shipping info.
        - items: cart represenation for which to fetch tax and shipping info.
    */
    case GetShippingRatesAndTax(accountID: Int, address: SBAddress, items: [String:AnyObject])

    case GetStoreItemsForAccount(accountID: Int)

    case GetStoreItemWithID(storeItemID: Int, accountID: Int)

    /**
    Purchase storeItem(s)
    */
    case PurchaseItems(items: [String:AnyObject],
        purchaseToken: String,
        address: SBAddress,
        shippingDetails: [String:AnyObject],
        totals: [String:AnyObject],
        notes: String,
        email: String,
        accountID: Int)

    case AddPaymentForSplitPurchase(orderID: Int,
        amount: NSDecimalNumber,
        token: String,
        accountID: Int)

    case RequestStripeAuthorization(requestToken: String, accountID: Int)

    case GetStoreDashboard(accountID: Int)

// MARK: Push endpoints

    case SetPushTokenForAuthenticatedUser(token: String)

// MARK: Notification endpoints

    case GetNotifications(accountID: Int)
}

extension API {

    // Base CocoaBlocAPI URL
    public var baseURL: NSURL { return NSURL(string: "https://api.stagebloc.com/v1")! }
    
    // Full resolved URL
    public var URL: NSURL { return self.baseURL.URLByAppendingPathComponent(path) }
}



