//
//  UserPhoto+Argo.Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry
import Runes

extension UserPhoto: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<UserPhoto> {
		return curry(UserPhoto.init)
			<^> json <| "width"
			<*> json <| "height"
			<*> json <| "images"
	}

}
