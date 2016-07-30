//
//  Blog+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Blog: Decodable {
	
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