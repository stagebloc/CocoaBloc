//
//  NSDate.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Foundation

extension NSDate: Decodable {
	public static func decode(json: JSON) -> Decoded<NSDate> {
		switch json {
		case .String(let string):
			return .fromOptional(API.DateFormatter(withTimeZone: false).dateFromString(string))
		default:
			return .typeMismatch("Date String", actual: json)
		}
	}
}
