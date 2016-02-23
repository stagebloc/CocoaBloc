//
//  API+Content.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension API {
	
	public static func likeContent<T: SBContent>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
			method: .POST)
	}
	
	public static func unlikeContent<T: SBContent>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
			method: .DELETE)
	}
	
	public static func deleteContent(content: ContentType) -> Endpoint<()> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
			method: .DELETE)
	}
	
	public static func getUsersWhoLikeContent<T: SBContent>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/likers",
			method: .GET)
	}
	
	public static func getContent<T: SBContent>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
			method: .GET)
	}
    
    public static func getContentForAccount(accountID: Int,
                       range: Range<Int>,
                       filter filteredTypes: [ContentTypeIdentifier] = []
        ) -> Endpoint<[SBContent]> {
        return Endpoint(
            path: "account/\(accountID)/content",
            method: .GET,
            parameters: [
                "filter": filteredTypes.map { $0.rawValue }.joinWithSeparator(","),
                "offset": range.startIndex,
                "limit": range.endIndex - range.startIndex
            ])
    }
	
	public static func flagContent<T: SBContent>(
		content: ContentType,
		type: FlagType,
		reason: String
	) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType)/\(content.contentID)/flag",
			method: .POST,
			parameters: [
				"type": type.rawValue,
				"reason": reason
			])
	}
}
