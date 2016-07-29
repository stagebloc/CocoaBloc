//
//  Status.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Status: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let shortURL: NSURL
	public let text: String
	public let category: String
	public let inModeration: Bool
	public let isFanContent: Bool
	public let publishDate: NSDate
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
	public static func decode(json: JSON) -> Decoded<Status> {
		let a = curry(Status.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "short_url"
			<*> json <| "text"
			<*> json <| "category"
			<*> json <| "in_moderation"
		return a
			<*> json <| "is_fan_content"
			<*> json <| "published"
			<*> json <| "commentCount"
			<*> json <| "likeCount"
			<*> json <| "user"
	}
}
