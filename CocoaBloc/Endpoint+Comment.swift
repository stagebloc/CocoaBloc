//
//  Endpoint+Comment.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension StageBloc {
    
    public static func getCommentsForContent(content: ContentType) -> Endpoint<[SBComment]> {
        return Endpoint(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comments",
            method: .GET)
    }
    
    public static func getRepliesToComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier) -> Endpoint<[SBComment]> {
        return Endpoint(
            path: "account/\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
            method: .GET)
    }
    
    public static func deleteComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier) -> Endpoint<()> {
        return Endpoint(
            path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
            method: .DELETE)
    }
    
    public static func postComment(text: String, onContent content: ContentType) -> Endpoint<SBComment> {
        return Endpoint(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comment",
            method: .POST,
            parameters: ["text": text])
    }
    
    public static func getComment(commentID: Int, content: ContentType) -> Endpoint<SBComment> {
        return Endpoint(
            path: "account\(content.postedAccountID)/\(content.contentType.rawValue)/comment/\(commentID)",
            method: .GET)
    }
    
    public static func flagComment(commentID: Int, contentType: ContentTypeIdentifier, accountID: Int, type: FlagType, reason: String) -> Endpoint<()> {
        return Endpoint(
            path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)/flag",
            method: .POST,
            parameters: [
                "type": type.rawValue,
                "reason": reason
            ])
    }
}
