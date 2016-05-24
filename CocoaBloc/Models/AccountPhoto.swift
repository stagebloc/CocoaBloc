//
//  AccountPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public enum ImageSize {
	case Thumbnail
	case Small
	case Medium
	case Large
	case Original
}

public struct AccountPhoto: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let category: String
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let shortURL: NSURL
	public let descriptiveText: String
	public let width: Int
	public let height: Int
	public let sticky: Bool
	public let exclusive: Bool
	public let inModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
//	public let imageURLs: [ImageSize:NSURL]
	public let user: Expandable<User>
	
	public static func decode(json: JSON) -> Decoded<AccountPhoto> {
		let a = curry(AccountPhoto.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "category"
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
			<*> json <| "user"
	}
}
