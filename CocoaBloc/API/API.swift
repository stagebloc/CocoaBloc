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

/// Protocol describing a type containing necessary information to reference content
public protocol ContentType {
    
    /// Which type of content the identifier belongs to
    var contentType: API.ContentTypeIdentifier { get }
    
    /// The identifier of the content itself
    var contentID: Int { get }
    
    /// The identifier of the account on which this content is posted
    var accountID: Int { get }
}

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
    
    /**
    Request the currently authenticated user for the SBClient.
    */
    case GetCurrentlyAuthenticatedUser
    
    /**
     Ban user from specified account.
     
     - Parameters:
     - userID: identifier of user to be banned.
     - accountID: identifier of account from which to ban user.
     - reason: String containing a reason why user is to be banned.
     */
    case BanUser(userID: Int, accountID: Int, reason: String)

    /**
     Requests password reset to specified email address.
     
     - Parameters:
     - email: email address to send passoword reset.
     */
    case SendPasswordReset(email: String)

    case UpdateAuthenticatedUserLocation(latitude: Double, longitude: Double)

    /**
     Request the StageBloc user by their user id.
     
     - Parameters:
     - userID: identifier of user to be requested.
     */
    case GetUser(userID: Int)
    
    public enum UserColor: String {
        case Blue   = "blue"
        case Teal   = "teal"
        case Green  = "green"
        case Pink   = "pink"
        case Red    = "red"
        case Purple = "purple"
    }

    public enum Gender: String {
        case Male       = "male"
        case Female     = "female"
        case Cupcake    = "cupcake"
    }

    /**
     Request the StageBloc user by their user id.
     
     - Parameters:
     - params: NSDictionary containing user information to be updated.
     */
    case UpdateAuthenticatedUser(
        bio: String?,
        birthday: NSDate?,
        email: String?,
        username: String?,
        name: String?,
        gender: Gender?,
        color: UserColor?)
    
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
    case SignUp(
        email: String,
        name: String,
        password: String,
        bio: String?,
        birthday: NSDate,
        gender: Gender,
        sourceAccountID: Int?)


    /**
    Request a list of content the user has either submitted or liked.

    - Parameters:
        - userID: identifier of user for whose content to fetch.
        - contentListType: specifies either a list of user-submitted content ('SBUserContentListTypeUpdate')
        or user-liked content ('SBUserContentListTypeLike').
        - parameters: additional parameters.
    */
    public enum UserContentType: String {
        case Likes      = "likes"
        case Updates    = "Updates"
    }
    case GetPostedContentFromUser(userID: Int, type: UserContentType)

// MARK: Account endpoints

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
    case CreateAccount(
        name: String,
        description: String,
        url: String,
        type: AccountType,
        color: AccountColor)

    
    /**
     Update an account with one or more new properties. Only admins of the account are allowed to do this
     
     - Parameters:
     - name: the new account name, or nil.
     - description: description the new account description, or nil.
     - stageBlocURL: the new StageBloc URL path component for the account, or nil.
     - type: type of account (ex. 'Business', 'Cooking', 'Record Label', etc), or nil.
     - color: account color.
     */
    case UpdateAccount(
        accountID: Int,
        name: String,
        description: String,
        url: String,
        type: AccountType,
        color: AccountColor)


    /**
    Update account photo data

    - Parameters:
        - accountID: identifier of the account for which to update photo.
        - photoData: the profile photo of the account.
    */
    case UpdateAccountImage(accountID: Int)

    /**
     Gets all of the accounts associated with the given user identifier, with options to filter admin and following accounts.
     */
    case GetAccountsForUser(userID: String, includeAdminAccounts: Bool, includeFollowingAccounts: Bool)

    /**
     Get an account based on an account ID.
     */
    case GetAccount(accountID: Int)
    
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
    case FollowAccount(accountID: Int)

    /**
    Unfollow an account with its associated identifier
    */
    case UnfollowAccount(accountID: Int)

    /**
    Get the currently authenticated user's accounts.
    */
    case GetAuthenticatedUserAccounts

// MARK: Content endpoints
    
    public enum ContentTypeIdentifier: String {
        case Photo  = "photo"
        case Audio  = "audio"
        case Video  = "video"
        case Blog   = "blog"
        case Status = "status"
    }
    public struct Content: ContentType {
        public let contentType: ContentTypeIdentifier
        public let contentID: Int
        public let accountID: Int
    }

    /**
    Like a piece of content.
    */
    case LikeContent(ContentType)

    /**
    Un-like a piece of content.
    */
    case UnlikeContent(ContentType)

    /**
    Delete a piece of content.
    */
    case DeleteContent(ContentType)

    /**
    Fetch a list of users who like a piece of content.
    */
    case GetUsersWhoLikeContent(ContentType)

    /**
    Fetch a content object.

    - Parameters:
        - contentID: identifier for the content.
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to
    */
    case GetContent(ContentType)
    
    /**
    Flag a content object.

    - Parameters:
        - contentIdentifier: identifier for the content..
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to.
        - type: string of preset values which can be used for reasons why someone flagged a piece of content
        - reason: reason for flagging content
    */
    public enum FlagType: String {
        case Duplicate = "duplicate"
        case Copyright = "copyright"
        case Prejudice = "prejudice"
        case Offensive = "offensive"
    }
    case FlagContent(
        ContentType,
        type: FlagType,
        reason: String)

    /**
    Post status to account. Convenience method for posting statuses.

    - Parameters:
        - status: the status to be posted.
        - accountID: identifier of account to which status is to be posted.
        - fanContent: indicates whether status is submitted by a fan of the account.
    */
    case PostStatus(
        text: String,
        accountID: Int,
        fanContent: Bool,
        location: (longitude: Double, latitude: Double)?)

    /**
    Post blog to account. Convenience method for posting statuses.

    - Parameters:
        - title: title of blog post.
        - body: body of blog post.
        - accountID: identifier of account to which status is to be posted.
    */
    case PostBlog(title: String, body: String, accountID: Int)

    /**
    Upload a photo directly to the specified account.

    - Parameters:
        - photoID: identifier of photo to be fetched
        - account: associated account of the photo
    */
    case UploadPhoto(
        title: String,
        description: String,
        accountID: Int,
        exclusive: Bool,
        fanContent: Bool)

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
    case UploadVideo(
        title: String,
        description: String,
        accountID: Int,
        exclusive: Bool,
        fanContent: Bool)

    /**
    Track video events.

    - Parameters:
        - event: video event, supported events -> (play, ended, loop).
        - videoID: the video identifier of the associated event.
        - accountID: identifier of account associated with video.
    */
    public enum VideoEvent: String {
        case Loop   = "loop"
        case Play   = "play"
        case Ended  = "ended"
    }
    case TrackVideoEvent(VideoEvent, videoID: Int, accountID: Int)
    
    /**
     Fetch audio track.
     
     - Parameters:
     - data: valid audio track data.
     - title: audio track title.
     - fileName: the path or name of the audio track file.
     - account: identifier of account associated with audio track.
     */
    case UploadAudio(title: String, accountID: Int)

    // Playlists
    
    case GetPlaylist(playlistID: Int, accountID: Int)
    
    case GetPlaylistsForAccount(accountID: Int)

   
// MARK: Comment endpoints

    /**
    Fetch comments for a content object.

    - Parameters:
        - content: content object for which to fetch comments.
    */
    case GetCommentsForContent(ContentType)

    /**
    Fetch replies (i.e. comments) to a particular comment.

    - Parameters:
        - comment: comment object for which to fetch replies.
    */
    case GetRepliesToComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier)
    
    /**
    Deletes a comment.
    */
    case DeleteComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier)

    /**
    Post a comment to a piece of content.
    */
    case PostCommentOnContent(text: String, content: ContentType)

    /**
    Post a comment in reply to another comment.
    */
    case PostReplyToComment(text: String, content: ContentType)

    /**
    Fetch a comment for a piece of content from the comment's identifier.
    */
    case GetComment(commentID: Int, content: ContentType)

    /**
    Flag a comment.
    */

    case FlagComment(
        commentID: Int,
        contentType: ContentTypeIdentifier,
        accountID: Int,
        type: FlagType,
        reason: String)


// MARK: Fanclub endpoints
    
    /**
    Retrieves the fan club dashboard details for the account.
    */
    case GetFanClubDashboard(accountID: Int)

    /**
    Create the fan club for the given StageBloc account.

    - Parameters:
        - accountID: the parent/fan-club-owning StageBloc account object.
        - title: the title for the fan club.
        - description: the description for the fan club.
        - tierInfo: a dictionary with any of the following tier info keys, or nil.
    */
    case CreateFanClub(accountID: Int, title: String, description: String, tierInfo: [String:AnyObject])

    public enum FanClubType: String {
        case Featured   = "featured"
        case Recent     = "recent"
        case Following  = "following"
    }
    case GetFanClubs(accountID: Int, type: FanClubType)
    
    case GetFanClubFans(accountID: Int)
    
    /**
     Retrieves the content for fan clubs that the user follows.
     */
    case GetContentFromFollowedFanClubs

    case GetFanClub(accountID: Int)
    
    /**
    Get an array of content associated with a Fan Club.
    */
    case GetFanClubContent(accountID: Int)


// MARK: Store endpoints

    case GetStoreDashboard(accountID: Int)

    case GetOrders(accountID: Int)
    
    case SetOrderShipped(orderID: Int, accountID: Int, trackingNumber: String, carrier: String)
    
    case GetStoreItemsForAccount(accountID: Int)

    case GetStoreItem(storeItemID: Int, accountID: Int)

    
    // Commerce
    
    /**
    Requests tax and shipping information for a given cart and address. Returns RACTuple with first object = SBShippingRateSet and second object = NSDecimalNumber (taxTotal)

    - Parameters:
        - accountID: accountID of account from which items are being purchased.
        - address: SBAddress for which to fetch tax and shipping info.
        - items: cart represenation for which to fetch tax and shipping info.
    */
    case GetShippingRatesAndTax(accountID: Int, address: SBAddress, items: [String:AnyObject])



    /**
    Purchase storeItem(s)
    */
    case PurchaseItems(
        items: [String:AnyObject],
        amount: Double,
        purchaseToken: String,
        address: SBAddress,
        shippingDetails: [String:AnyObject],
        totals: [String:AnyObject],
        notes: String,
        email: String,
        cash: Bool,
        accountID: Int)

    case AddPaymentForSplitPurchase(
        orderID: Int,
        amount: NSDecimalNumber,
        token: String,
        accountID: Int)

    case RequestStripeAuthorization(requestToken: String, accountID: Int)


// MARK: Push endpoints

    case SetPushTokenForAuthenticatedUser(token: String)

// MARK: Notification endpoints

    case GetNotifications
    
    // Events
    case GetEvents(accountID: Int)
    
    // Coupons
    case GetCoupon(accountID: Int, couponID: Int)
    
    case ValidateCoupon(accountID: Int, couponCode: String)
}

extension API {

    // Base CocoaBlocAPI URL
    public var baseURL: NSURL { return NSURL(string: "https://api.stagebloc.com/v1")! }
    
    // Full resolved URL
    public var URL: NSURL { return self.baseURL.URLByAppendingPathComponent(path) }
}



