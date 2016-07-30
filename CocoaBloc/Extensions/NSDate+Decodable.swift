//
//  NSDate.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

extension NSDate: Decodable {
	
	public static func decode(json: JSON) -> Decoded<NSDate> {
		guard case .String(let string) = json else {
			return .typeMismatch("Date String", actual: json)
		}
		return .fromOptional(API.DateFormatter(withTimeZone: false).dateFromString(string))
	}
	
}
