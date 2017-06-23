//
//  User+Argo.Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension User: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<User> {
		let a = curry(User.init)
			<^> json <| "id"
			<*> json <|? "url"
			<*> json <| "created"
			<*> json <| "name"
			<*> json <| "username"
		return a
			<*> json <|? "bio"
			<*> json <|? "photo"
			//			<*> json <|? "birthday"
			<*> json <|? "gender"
			<*> json <|? "email"
			<*> json <| "color"
	}
	
}
