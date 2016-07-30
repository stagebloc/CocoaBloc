//
//  UserPhoto+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension UserPhoto: Decodable {
	
	public static func decode(json: JSON) -> Decoded<UserPhoto> {
		return curry(UserPhoto.init)
			<^> json <| "width"
			<*> json <| "height"
			<*> json <| "images"
	}

}
