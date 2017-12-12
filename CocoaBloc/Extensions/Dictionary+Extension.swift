//
//  Dictionary+Extension.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-07.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

import Foundation

extension Dictionary {
	
	internal func filterEntriesWithNilValues() -> [Key: Value] {
		var ret = [Key: Value]()
		for key in keys {
			if let val = self[key] {
				if val as AnyObject !== NSNull() {
					ret[key] = val
				}
			}
		}
		return ret
	}
	
//	func stringFromHttpParameters() -> String {
//		let parameterArray = self.map { (key, value) -> String in
//			let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
//			let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
//			return "\(percentEscapedKey)=\(percentEscapedValue)"
//		}
//
//		return parameterArray.joined(separator: "&")
//	}
	
	func stringFromHttpParameters() -> String {
		let parameterArray = self.map { args -> String in
			let (key, value) = args
			let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
			let percentEscapedValue = ("\(value)").addingPercentEncodingForURLQueryValue()!
			return "\(percentEscapedKey)=\(percentEscapedValue)"
		}
		
		return parameterArray.joined(separator: "&")
	}
}
