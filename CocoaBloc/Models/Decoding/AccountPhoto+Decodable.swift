//
//  AccountPhoto+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension AccountPhoto: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<AccountPhoto> {
		let a = curry(AccountPhoto.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <|? "category"
			<*> json <| "created"
			<*> json <| "modified"
			<*> json <| "short_url"
		return a
			<*> json <| "description"
			<*> json <| "width"
			<*> json <| "height"
			<*> json <| "sticky"
			<*> json <| "exclusive"
			<*> json <| "in_moderation"
			<*> json <| "is_fan_content"
			<*> json <| "comment_count"
			<*> json <| "like_count"
			<*> json <| "images"
			<*> json <| "user"
	}
	
}
