//
//  NSURL.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

extension NSURL: Decodable {
	public static func decode(json: JSON) -> Decoded<NSURL> {
		switch json {
		case .String(let string):
			return .fromOptional(NSURL(string: string))
		default:
			return .typeMismatch("URL String", actual: json)
		}
	}
}
