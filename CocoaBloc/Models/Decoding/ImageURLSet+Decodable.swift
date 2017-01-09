//
//  ImageURLSet+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension ImageURLSet: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<ImageURLSet> {
		return curry(ImageURLSet.init)
			<^> json <| "thumbnail_url"
			<*> json <| "small_url"
			<*> json <| "medium_url"
			<*> json <| "large_url"
			<*> json <| "original_url"
	}

}
