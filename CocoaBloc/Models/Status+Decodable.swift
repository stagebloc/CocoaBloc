//
//  Status+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Status: Decodable {
	
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
