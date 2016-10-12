//
//  User+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension User: Decodable {
	
	public static func decode(json: JSON) -> Decoded<User> {
		let a = curry(User.init)
			<^> json <| "id"
			<*> json <| "url"
			<*> json <| "created"
			<*> json <| "name"
			<*> json <| "username"
			<*> json <|? "bio"
		return a
			<*> json <|? "photo"
			//			<*> json <|? "birthday"
			<*> json <|? "gender"
			<*> json <|? "email"
			<*> json <| "color"
	}
	
}
