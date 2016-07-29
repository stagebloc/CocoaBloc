//
//  SequenceTypeExtensions.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/29/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

extension SequenceType where Generator.Element == (String, AnyObject?) {
	
	/// Removes all dictionary entries where the value type is Optional<T> and is .None
	/// - returns: a new dictionary guaranteed and typed to contain no nil values pairs
	internal func filterEntriesWithNilValues() -> [String:AnyObject] {
		var ret = [String:AnyObject]()
		for (key, value) in self where value != nil {
			ret[key] = value!
		}
		return ret
	}
	
}
