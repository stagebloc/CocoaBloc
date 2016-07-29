//
//  ImageURLSet.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/26/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct ImageURLSet: Decodable {
	
	public let thumbnail: NSURL
	public let small: NSURL
	public let medium: NSURL
	public let large: NSURL
	public let original: NSURL
	
	public static func decode(json: JSON) -> Decoded<ImageURLSet> {
		return curry(ImageURLSet.init)
			<^> json <| "thumbnail_url"
			<*> json <| "small_url"
			<*> json <| "medium_url"
			<*> json <| "large_url"
			<*> json <| "original_url"
	}
}
