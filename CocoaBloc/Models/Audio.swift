//
//  Audio.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Audio: APIObject {
	
	public let id: Int
	public let account: Expandable<Account>
	public let title: String
	public let category: String
	public let duration: Float
	public let descriptiveText: String
	public let lyrics: String
	public let artist: String
	public let photo: Expandable<AccountPhoto>
	public let creator: Expandable<User>
	public let creationDate: Date
	public let modifier: Expandable<User>
	public let modificationDate: Date
	public let isRecorded: Bool
	public let shortURL: URL
	public let streamURL: URL
	public let embedCode: String
	public let isPrivate: Bool
	public let isSticky: Bool
	public let isExclusive: Bool
	public let inModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
//	public static func decode(json: JSON) -> Decoded<Audio> {
//		let a = curry(Audio.init)
//			<^> json <| "id"
//			<*> json <| "account"
//			<*> json <| "title"
//			<*> json <| "category"
//			<*> json <| "duration"
//		let b = a
//			<*> json <| "description"
//			<*> json <| "lyrics"
//			<*> json <| "artist"
//			<*> json <| "photo"
//		let c = b
//			<*> json <| "created_by"
//			<*> json <| "created"
//			<*> json <| "modified_by"
//			<*> json <| "modified"
//			<*> json <| "recorded"
//			<*> json <| "short_url"
//			<*> json <| "stream_url"
//			<*> json <| "embed_code"
//			<*> json <| "private"
//			<*> json <| "sticky"
//		return c
//			<*> json <| "exclusive"
//			<*> json <| "in_moderation"
//			<*> json <| "is_fan_content"
//			<*> json <| "commentCount"
//			<*> json <| "likeCount"
//			<*> json <| "user"
//	}
	
}
