//
//  UserPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/27/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct UserPhoto: Decodable {
	
	public let width: Int
	public let height: Int
	public let imageURLs: ImageURLSet
	
	public static func decode(json: JSON) -> Decoded<UserPhoto> {
		return curry(UserPhoto.init)
			<^> json <| "width"
			<*> json <| "height"
			<*> json <| "images"
	}
}
