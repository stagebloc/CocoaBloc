//
//  User.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct User: Decodable, Identifiable {
	
	public let identifier: Int
	public let url: NSURL
	public let creationDate: NSDate
	public let name: String
	public let username: String
	public let bio: String
	public let photo: UserPhoto?
//	public let birthday: NSDate?
	public let gender: String?
	public let emailAddress: String?
	public let color: RGBComponents
	
	public static func decode(json: JSON) -> Decoded<User> {
		let a = curry(User.init)
			<^> json <| "id"
			<*> json <| "url"
			<*> json <| "created"
			<*> json <| "name"
			<*> json <| "username"
			<*> json <| "bio"
		return a
			<*> json <|? "photo"
//			<*> json <|? "birthday"
			<*> json <|? "gender"
			<*> json <|? "email"
			<*> json <| "color"
	}
}
