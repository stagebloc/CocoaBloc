//
//  Blog.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct Blog: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let body: String
	public let strippedBody: String
	public let category: String
	public let slug: String
	public let shortURL: NSURL
	public let publishDate: NSDate
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let isSticky: Bool
	public let isExclusive: Bool
	public let inModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
	public static func decode(json: JSON) -> Decoded<Blog> {
		let a = curry(Blog.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "body"
			<*> json <| "body_stripped"
			<*> json <| "category"
			<*> json <| "slug"
			<*> json <| "short_url"
			<*> json <| "published"
		return a
			<*> json <| "created"
			<*> json <| "modified"
			<*> json <| "sticky"
			<*> json <| "exclusive"
			<*> json <| "in_moderation"
			<*> json <| "is_fan_content"
			<*> json <| "commentCount"
			<*> json <| "likeCount"
			<*> json <| "user"
	}
}
