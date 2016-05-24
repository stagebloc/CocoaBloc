//
//  NSDateFormatter.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Foundation

extension NSDateFormatter {
	static func CocoaBlocJSONDateFormatter() -> NSDateFormatter {
		let ret = NSDateFormatter()
		ret.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
		ret.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		ret.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return ret
	}
}
