//
//  URL.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

extension URL: Decodable {
	
	public static func decode(json: JSON) -> Decoded<URL> {
		guard case .String(let string) = json else {
			return .typeMismatch("URL String", actual: json)
		}
		return .fromOptional(NSURL(string: string).flatMap(URL.init))
	}
	
}
