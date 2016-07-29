//
//  Video.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Video: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let descriptiveText: String
	public let category: String
	public let photo: Expandable<AccountPhoto>
	public let shortURL: NSURL
	public let videoURL: NSURL
	public let embedCode: String
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let isExclusive: Bool
	public let inModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
	public static func decode(json: JSON) -> Decoded<Video> {
		let a = curry(Video.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "description"
			<*> json <| "category"
			<*> json <| "photo"
			<*> json <| "short_url"
			<*> json <| "video_url"
			<*> json <| "embed_code"
		return a
			<*> json <| "creation_date"
			<*> json <| "modification_date"
			<*> json <| "exclusive"
			<*> json <| "in_moderation"
			<*> json <| "is_fan_content"
			<*> json <| "comment_count"
			<*> json <| "like_count"
			<*> json <| "user"
	}
}
