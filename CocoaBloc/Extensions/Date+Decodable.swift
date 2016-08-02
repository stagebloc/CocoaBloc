//
//  Date.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

public struct Date {
	static let formatter: NSDateFormatter = {
		let ret = NSDateFormatter()
		ret.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
		ret.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		ret.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return ret
	}()
	
	public let date: NSDate
}

extension Date: Decodable {
	public static func decode(json: JSON) -> Decoded<Date> {
		guard case .String(let string) = json else {
			return .typeMismatch("Date String", actual: json)
		}
		return .fromOptional(Date.formatter.dateFromString(string).flatMap(Date.init))
	}
}
