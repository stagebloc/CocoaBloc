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
	//	var color: UIColor
	
	public static func decode(json: JSON) -> Decoded<User> {
		return curry(User.init)
			<^> json <| "id"
			<*> json <| "url"
			<*> json <| "created"
			<*> json <| "name"
			<*> json <| "username"
			<*> json <| "bio"
		//			<*> j <| "color"
	}
}
