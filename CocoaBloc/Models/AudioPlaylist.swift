//
//  AudioPlaylist.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct AudioPlaylist: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let descriptiveText: String
	public let shortURL: NSURL
	public let embedCode: String
	public let creator: Expandable<User>
	public let creationDate: NSDate
	public let modifier: Expandable<User>
	public let modificationDate: NSDate
	public let likeCount: Int
	public let artist: String
	public let label: String
	public let photo: AccountPhoto?
//	public let audio: [Audio]
	
	public static func decode(json: JSON) -> Decoded<AudioPlaylist> {
		let a = curry(AudioPlaylist.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "description"
			<*> json <| "short_url"
			<*> json <| "embed_code"
			<*> json <| "created_by"
			<*> json <| "created"
		return a
			<*> json <| "modified_by"
			<*> json <| "modified"
			<*> json <| "like_count"
			<*> json <| "artist"
			<*> json <| "label"
			<*> json <|? "photo"
//			<*> json <| "
	}
}