//
//  API+Comment.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation

extension API {
	
	public static func getComments(forContent content: ContentType) -> Endpoint<[Comment]> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comments",
			method: .GET)
	}
	
	public static func getRepliesToComment(
		withIdentifier commentID: Int,
		accountID: Int,
		contentType: ContentTypeIdentifier) -> Endpoint<[Comment]> {
		return Endpoint(
			path: "account/\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
			method: .GET)
	}
	
	public static func deleteComment(
		withIdentifier commentID: Int,
		accountID: Int,
		contentType: ContentTypeIdentifier) -> Endpoint<()> {
		return Endpoint(
			path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)",
			method: .DELETE)
	}
	
	public static func postComment(
		withText text: String,
		onContent content: ContentType) -> Endpoint<Comment> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/comment",
			method: .POST,
			parameters: ["text": text])
	}
	
	public static func getComment(
		withIdentifier commentID: Int,
		content: ContentType) -> Endpoint<Comment> {
		return Endpoint(
			path: "account\(content.postedAccountID)/\(content.contentType.rawValue)/comment/\(commentID)",
			method: .GET)
	}
	
	public static func flagComment(
		withIdentifier commentID: Int,
		contentType: ContentTypeIdentifier,
		accountID: Int,
		type: FlagType,
		reason: String) -> Endpoint<()> {
		return Endpoint(
			path: "account\(accountID)/\(contentType.rawValue)/comment/\(commentID)/flag",
			method: .POST,
			parameters: [
				"type": type.rawValue,
				"reason": reason
			])
	}
	
}
