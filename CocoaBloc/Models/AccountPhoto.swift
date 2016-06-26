//
//  AccountPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct AccountPhoto: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let category: String?
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let shortURL: NSURL
	public let descriptiveText: String
	public let width: Int
	public let height: Int
	public let isSticky: Bool
	public let isExclusive: Bool
	public let isInModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let imageURLs: ImageURLSet
	public let user: Expandable<User>
	
	public static func decode(json: JSON) -> Decoded<AccountPhoto> {
		let a = curry(AccountPhoto.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <|? "category"
			<*> json <| "created"
			<*> json <| "modified"
			<*> json <| "short_url"
		return a
			<*> json <| "description"
			<*> json <| "width"
			<*> json <| "height"
			<*> json <| "sticky"
			<*> json <| "exclusive"
			<*> json <| "in_moderation"
			<*> json <| "is_fan_content"
			<*> json <| "comment_count"
			<*> json <| "like_count"
			<*> json <| "images"
			<*> json <| "user"
	}
}
