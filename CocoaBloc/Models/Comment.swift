//
//  Comment.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Comment: Decodable, Identifiable {
	
	public let identifier: Int
	public let text: String
	public let user: Expandable<User>
	public let creationDate: NSDate
	public let account: Expandable<Account>
	public let replyToIdentifier: Int
	public let replyCount: Int
	public let shortURL: NSURL
	public let inModeration: Bool
	
	public static func decode(json: JSON) -> Decoded<Comment> {
		return curry(Comment.init)
			<^> json <| "id"
			<*> json <| "text"
			<*> json <| "user"
			<*> json <| "created"
			<*> json <| "account"
			<*> json <| "reply_to"
			<*> json <| "reply_count"
			<*> json <| "short_url"
			<*> json <| "in_moderation"
	}
}
