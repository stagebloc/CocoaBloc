//
//  URL.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

extension URL: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<URL> {
		guard case .string(let string) = json else {
			return .typeMismatch(expected: "URL String", actual: json)
		}
		return .fromOptional(URL(string: string))//.flatMap(URL.init))
	}
	
}
