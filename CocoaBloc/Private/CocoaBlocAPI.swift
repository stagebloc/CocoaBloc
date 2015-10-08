//
//  CocoaBlocAPI.swift
//  CocoaBloc
//
//  Created by David Warner on 10/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveMoya

// Endpoint enum declarations
public enum CocoaBlocAPI {

// MARK: Auth endpoints

    /**
    Complete the log in process with an authorization code from StageBloc, usually obtained from SBAuthenticationController.

    - Parameters:
        - authorizationCode: The authorization code.
    */
    case loginWithAuthorizationCode(authorizationCode : String)

    /**
    Log in a StageBloc user with the given credentials.

    - Parameters:
        - username: The user's username/email address.
        - password: The user's password.
    */
    case logInWithUsername(username : String,
        password : String)


// MARK: User endpoints


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
    case signupUser(email : String,
        name : String,
        password : String,
        birthday : NSDate,
        gender : String,
        sourceAccountID : NSNumber)

    /**
    Request the currently authenticated user for the SBClient.
    */
    case getCurrentlyAuthenticatedUser

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - userID: identifier of user to be requested.
    */
    case getUser(userID : NSNumber)

    /**
    Request the StageBloc user by their user id.

    - Parameters:
        - params: NSDictionary containing user information to be updated.
    */
    case updateAuthenticatedUserWithParameters(params : [String:AnyObject])

    /**
    Ban user from specified account.

    - Parameters:
        - userID: identifier of user to be banned.
        - accountID: identifier of account from which to ban user.
        - reason: String containing a reason why user is to be banned.
    */
    case banUser(userID : NSNumber,
        accountID : NSNumber,
        reason : String)

    /**
    Request a list of content the user has either submitted or liked.

    - Parameters:
        - userID: identifier of user for whose content to fetch.
        - contentListType: specifies either a list of user-submitted content ('SBUserContentListTypeUpdate')
        or user-liked content ('SBUserContentListTypeLike').
        - parameters: additional parameters.
    */
    case getPostedContentFromUser(userID : NSNumber,
        contentListType : String,
        parameters : [String:AnyObject])

    /**
    Requests password reset to specified email address.

    - Parameters:
        - email: email address to send passoword reset.
    */
    case sendPasswordReset(email : String)

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
    case getAccount(accountID : NSNumber)

    /**
    Gets all of the accounts associated with the given user identifier, with options to filter admin and following accounts.
    */
    case getAccountsForUser(userIdentifier : String,
        includingAdminAccounts : Bool,
        followingAccounts : Bool,
        parameters : [String:AnyObject])

    /**
    Creates an account.

    - Parameters:
        - name: name of the new account.
        - url: the url which this account can be found.
        - type: type of the account being created.
        - color: one of: purple, red, green, blue, orange, grey.
    */
    case createAccount(name : String,
        url : String,
        type : String,
        color : String)

    /**
    Creates an account with a photo.

    - Parameters:
        - name: name of the new account.
        - url: the url which this account can be found.
        - type: type of the account being created.
        - photoData: the profile photo of the account.
        - photoProgressSignal: the photo progress upload signal.
    */
    case createAccountWithPhoto(
        name: String,
        url: String,
        type: String,
        photoData: NSData,
//        photoProgressSignal: Signal<Float>,
        parameters: [String:AnyObject])

    /**
    Update an account with one or more new properties. Only admins of the account are allowed to do this

    - Parameters:
        - name: the new account name, or nil.
        - description: description the new account description, or nil.
        - stageBlocURL: the new StageBloc URL path component for the account, or nil.
        - type: type of account (ex. 'Business', 'Cooking', 'Record Label', etc), or nil.
        - color: account color.
    */
    case updateAccount(accountID : NSNumber,
        name : String,
        description : String,
        stageBlocURL : String,
        type : String,
        color : String)

    /**
    Update account photo data

    - Parameters:
        - accountID: identifier of the account for which to update photo.
        - photoData: the profile photo of the account.
        - progressSignal: the photo progress upload signal.
    */
    case updateAccountImage(accountID : NSNumber,
        photoData : NSData,
        progressSignal : RACSignal)

    /**
    Get an activity stream of recent content for an account.
    */
    case getActivityStreamForAccount(accountID : NSNumber,
        parameters : [String:AnyObject])

    /**
    Get a list of users following an account.
    */
    case getFollowingUsersForAccount(accountID : NSNumber,
        parameters : [String:AnyObject])


    /**
    Fetch child accounts for a particular account

    - Parameters:
        - accountID: accountId the ID of the parent account.
        - type: type a specific type of child account to get (optional).
    */
    case getChildrenAccountsForAccount(accountID : NSNumber,
        type : String)

    /**
    Follow an account with its associated identifier
    */
    case followAccount(accountIdentifier : NSNumber)

    /**
    Unfollow an account with its associated identifier
    */
    case unfollowAccount(accountIdentifier : NSNumber)

    /**
    Get the currently authenticated user's accounts.
    */
    case getAuthenticatedUserAccounts(parameters : [String:AnyObject])


// MARK: Content endpoints


    /**
    Like a piece of content.
    */
    case likeContent(content : SBContent)

    /**
    Un-like a piece of content.
    */
    case unlikeContent(content : SBContent)

    /**
    Delete a piece of content.
    */
    case deleteContent(content : SBContent)

    /**
    Fetch a list of users who like a piece of content.
    */
    case getUsersWhoLikeContent(content : SBContent,
        parameters : [String:AnyObject])

    /**
    Fetch a content object.

    - Parameters:
        - contentID: identifier for the content.
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to
    */
    case getContentWithIdentifier(contentID : NSNumber,
        contentType : String,
        accountID : NSNumber,
        parameters : [String:AnyObject])

    /**
    Flag a content object.

    - Parameters:
        - content: content to be flagged.
        - contentType: type of content (i.e. blog, photo, etc).
        - reason: reason for flagging content
    */
    case flagContent(content : SBContent,
        contentType : String,
        reason : String)

    /**
    Flag a content object.

    - Parameters:
        - contentIdentifier: identifier for the content..
        - contentType: type of content (i.e. blog, photo, etc).
        - accountID: account content is posted to.
        - type: string of preset values which can be used for reasons why someone flagged a piece of content
        - reason: reason for flagging content
    */
    case flagContentWithIdentifier(contentIdentifier : NSNumber,
        contentType : String,
        accountID : NSNumber,
        type : String,
        reason : String)

    /**
    Post status to account. Convenience method for posting statuses.

    - Parameters:
        - status: the status to be posted.
        - accountID: identifier of account to which status is to be posted.
        - fanContent: indicates whether status is submitted by a fan of the account.
    */
    case postStatus(status : String,
        accountID : NSNumber,
        fanContent : Bool)

    /**
    Post status to account. Convenience method for posting statuses.

    - Parameters:
        - status: the status to be posted.
        - accountID: identifier of account to which status is to be posted.
        - fanContent: indicates whether status is submitted by a fan of the account.
        - latitude: latitude coordinate of posted status.
        - longitude: longitude coordinate of posted status.
    */
    case postStatusWithLocation(status : String,
        accountID : NSNumber,
        fanContent : Bool,
        latitude : NSNumber,
        longitude : NSNumber,
        parameters : [String:AnyObject])

    /**
    Post blog to account. Convenience method for posting statuses.

    - Parameters:
        - title: title of blog post.
        - body: body of blog post.
        - accountID: identifier of account to which status is to be posted.
    */
    case postBlog(title : String,
        body : String,
        accountID : NSNumber,
        parameters : [String:AnyObject])

    /**
    Get a photo from an account.

    - Parameters:
        - photoID: identifier of photo to be fetched
        - account: associated account of the photo
    */
    case getPhoto(photoID : NSNumber,
        account : SBAccount)

    /**
    Upload a photo directly to the specified account.

    - Parameters:
        - photoID: identifier of photo to be fetched
        - account: associated account of the photo
    */
    case uploadPhoto(data : NSData,
        title : String,
        caption : String,
        accountID : NSNumber,
        exclusive : Bool,
        fanContent : Bool,
//        progressSignal : Signal<NSNumber>,
        parameters : [String:AnyObject])

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
    case uploadVideoWithData(data : NSData,
        fileName : String,
        title : String,
        caption : String,
        accountID: NSNumber,
        exclusive : Bool,
        fanContent : Bool,
//        progressSignal : Signal<T, NoError>,
        parameters : [String:AnyObject])

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
    case uploadVideoAtPath(filePath : String,
        title : String,
        caption : String,
        accountID: NSNumber,
        exclusive : Bool,
        fanContent : Bool,
        //        progressSignal : Signal<T, NoError>,
        parameters : [String:AnyObject])

    /**
    Track video events.

    - Parameters:
        - event: video event, supported events -> (play, ended, loop).
        - videoID: the video identifier of the associated event.
        - accountID: identifier of account associated with video.
    */
    case trackVideoEvent(event : String,
        videoID : NSNumber,
        accountID : NSNumber)

    /**
    Fetch audio track.

    - Parameters:
        - audioID: audio track identifier.
        - accountID: identifier of account associated with audio track.
    */
    case getAudioTrackWithID(audioID : NSNumber,
        accountID : NSNumber)

    /**
    Fetch audio track.

    - Parameters:
        - data: valid audio track data.
        - title: audio track title.
        - fileName: the path or name of the audio track file.
        - account: identifier of account associated with audio track.
    */
    case uploadAudioData(data : NSData,
        title : String,
        fileName : String,
        account : SBAccount
//        progressSignal : Signal
    )


// MARK: Comment endpoints


    /**
    Fetch comments for a content object.

    - Parameters:
        - content: content object for which to fetch comments.
    */
    case getCommentsForContent(content : SBContent,
        parameters : [String:AnyObject])


    case getRepliesToComment(comment : SBComment,
        parameters : [String:AnyObject])


    case deleteComment(comment : SBComment)

    case postCommentOnContent(text : String,
        content : SBContent,
        parameters : [String:AnyObject])

    case postCommentInReplyToComment(text : String,
        comment : SBComment,
        parameters : [String:AnyObject])

    case getComment(commentID : NSNumber,
        content : SBContent)

    case flagComment(comment : SBComment,
        type : String,
        reason : String)

    case flagCommentWithIdentifier(commentID : NSNumber,
        contentType : String,
        accountID : NSNumber,
        type : String,
        reason : String)

}

extension CocoaBlocAPI : MoyaTarget {

    // Base CocoaBlocAPI URL
    public var baseURL: NSURL { return NSURL(string: "https://api.stagebloc.com/v1")! }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

