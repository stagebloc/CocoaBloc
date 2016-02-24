//
//  SequenceTypeExtensions.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/29/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

internal extension SequenceType where Generator.Element == (String, AnyObject?) {
	
	/// Removes all dictionary entries where the value type is Optional<T> and is .None
	/// - returns: a new dictionary guaranteed and typed to contain no nil values
	func filterNil() -> [String:AnyObject] {
		var ret = [String:AnyObject]()
		for tuple in self where tuple.1 != nil {
			ret[tuple.0] = tuple.1!
		}
		return ret
	}
}
