//
//  Comment+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension Comment: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Comment> {
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
