//
//  Video+Argo.Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension Video: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Video> {
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
