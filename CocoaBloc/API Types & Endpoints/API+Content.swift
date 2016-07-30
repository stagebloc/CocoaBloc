//
//  API+Content.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation

public protocol ContentStreamObject {
	var title: String { get }
	var creationDate: NSDate { get }
	var commentCount: Int { get }
	var likeCount: Int { get }
	var shortURL: NSURL { get }
	var userHasLiked: Bool { get }
	var account: Expandable<Account> { get }
}

extension Status: ContentStreamObject {
	
}

extension API {
	
	public static func likeContent<T: ContentStreamObject>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
			method: .POST)
	}
	
	public static func unlikeContent<T: SBContentStreamObject>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/like",
			method: .DELETE)
	}
	
	public static func deleteContent(content: ContentType) -> Endpoint<()> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
			method: .DELETE)
	}
	
	public static func getUsersWhoLikeContent<T: SBContentStreamObject>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)/likers",
			method: .GET)
	}
	
	public static func getContent<T: SBContentStreamObject>(content: ContentType) -> Endpoint<T> {
		return Endpoint(
			path: "account/\(content.postedAccountID)/\(content.contentType.rawValue)/\(content.contentID)",
			method: .GET)
	}
    
    public static func getContentForAccount(accountID: Int,
                       range: Range<Int>,
                       filter filteredTypes: [ContentTypeIdentifier] = [])
		-> Endpoint<[SBContentStreamObject]> {
        return Endpoint(
            path: "account/\(accountID)/content",
            method: .GET,
            parameters: [
                "filter": filteredTypes.map { $0.rawValue }.joinWithSeparator(","),
                "offset": range.startIndex,
                "limit": range.endIndex - range.startIndex
            ])
    }
	
	public static func flagContent<T: SBContentStreamObject>(
		content: ContentType,
		type: FlagType,
		reason: String) -> Endpoint<T> {
		return Endpoint(
			path: "/account/\(content.postedAccountID)/\(content.contentType)/\(content.contentID)/flag",
			method: .POST,
			parameters: [
				"type": type.rawValue,
				"reason": reason
			])
	}
	
	public static func postStatusToAccount(accountID: Int, text: String) -> Endpoint<[Status]> {
		return Endpoint(
			path: "/account/\(accountID)/status",
			method: .POST,
			parameters: [
				"text": text
			])
	}
	
	public static func postBlogToAccount(accountID: Int, title: String, body: String) -> Endpoint<Blog> {
		return Endpoint(
			path: "/account/\(accountID)/blog",
			method: .POST,
			parameters: [
				"title": title,
				"body": body
			])
	}
	
	public static func postPhotoToAccount(accountID: Int,
	                                      photoData: NSData,
	                                      title: String?,
	                                      description: String?,
	                                      exclusive: Bool?) -> Endpoint<AccountPhoto> {
		return Endpoint(
			path: "/account/\(accountID)/photo",
			method: .POST,
			parameters: [
				"title": title,
				"description": description,
				"exclusive": exclusive
			].filterEntriesWithNilValues(),
			formData: [FormDataPart(title: "photo", dataType: .Data(photoData))])
	}
	
}
