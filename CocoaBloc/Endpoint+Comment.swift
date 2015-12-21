//
//  Endpoint+Comment.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension Endpoint {
    
    public func getCommentsForContent(content: ContentType, expansions: [ExpandableValue] = []) -> Endpoint<[SBComment]> {
        return request(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comments",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getRepliesToComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier, expansions: [ExpandableValue] = []) -> Endpoint<[SBComment]> {
        return request(
            path: "account/\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
            method: .GET,
            expand: expansions
        )
    }
    
    public func deleteComment(commentID: Int, accountID: Int, contentType: ContentTypeIdentifier) -> Endpoint<()> {
        return request(
            path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
            method: .DELETE,
            expand: []
        )
    }
    
    public func postComment(text: String, onContent content: ContentType, expansions: [ExpandableValue] = []) -> Endpoint<SBComment> {
        return request(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comment",
            method: .POST,
            expand: expansions,
            parameters: ["text": text]
        )
    }
    
    //    public func postReply(text: String, toComment:
    
    public func getComment(commentID: Int, content: ContentType, expansions: [ExpandableValue] = []) -> Endpoint<SBComment> {
        return request(
            path: "account\(content.postedAccountID)/\(content.contentType.rawValue)/comment/\(commentID)",
            method: .GET,
            expand: expansions
        )
    }
    
    public enum FlagType: String {
        case Duplicate = "duplicate"
        case Copyright = "copyright"
        case Prejudice = "prejudice"
        case Offensive = "offensive"
    }
    
    public func flagComment(commentID: Int, contentType: ContentTypeIdentifier, accountID: Int, type: FlagType, reason: String) -> Endpoint<()> {
        return request(
            path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)/flag",
            method: .POST,
            expand: [],
            parameters: [
                "type": type.rawValue,
                "reason": reason
            ]
        )
    }
}
