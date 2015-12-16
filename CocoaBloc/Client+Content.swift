//
//  Client+Content.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/15/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

extension Client {
    public func likeContent<T: SBContent>(content: ContentType, expansions: [ExpandableValue] = []) -> Request<T> {
        return request(
            path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
            method: .POST,
            expand: expansions
        )
    }
    
    public func unlikeContent<T: SBContent>(content: ContentType, expansions: [ExpandableValue] = []) -> Request<T> {
        return request(
            path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
            method: .DELETE,
            expand: expansions
        )
    }
    
    public func deleteContent(content: ContentType) -> Request<()> {
        return request(
            path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
            method: .DELETE,
            expand: []
        )
    }
    
    public func getUsersWhoLikeContent<T: SBContent>(content: ContentType, expansions: [ExpandableValue] = []) -> Request<T> {
        return request(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/likers",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getContent<T: SBContent>(content: ContentType, expansions: [ExpandableValue] = []) -> Request<T> {
        return request(
            path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
            method: .GET,
            expand: expansions
        )
    }
    
    public func flagContent<T: SBContent>(content: ContentType, type: FlagType, reason: String, expansions: [ExpandableValue] = []) -> Request<T> {
        return request(
            path: "/account/\(content.postedAccountID)/\(content.contentType)/\(content.contentID)/flag",
            method: .POST,
            expand: expansions,
            parameters: [
                "type": type.rawValue,
                "reason": reason
            ]
        )
    }
    
    
}