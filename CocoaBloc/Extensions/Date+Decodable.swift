//
//  Date.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation

extension Date: Argo.Decodable {
	
	static let formatter: DateFormatter = {
		let ret = DateFormatter()
		ret.locale = Locale(identifier: "EN_US_POSIX")
		ret.timeZone = TimeZone(secondsFromGMT: 0)
		ret.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return ret
	}()
	
	public static func decode(_ json: JSON) -> Decoded<Date> {
		guard case .string(let string) = json else {
			return .typeMismatch(expected: "Date String", actual: json)
		}
		return .fromOptional(Date.formatter.date(from: string))
			
			//.fromOptional(Date.formatter.date(from: string).flatMap(Date.init))
	}
	
}
