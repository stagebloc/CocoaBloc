//
//  Dictionary+CocoaBloc.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/2/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

// This file contains helper functions/operators for combining dictionaries

extension Dictionary {
	
	internal mutating func addEntries(_ other: [Key:Value]) {
		for (key, value) in other {
			self[key] = value
		}
	}
	
	internal func withEntries(_ other: [Key:Value]) -> [Key:Value] {
		var ret = self
		ret.addEntries(other)
		return ret
	}
	
	internal func filterEntriesWithNilValues() -> [Key: AnyObject] {
		var ret = [Key: AnyObject]()
		for (key, value) in self {
			ret[key] = value as AnyObject
		}
		return ret
	}
	
}

internal func += <Key: Hashable, Value>(lhs: inout [Key:Value], rhs: [Key:Value]) {
	lhs.addEntries(rhs)
}

internal func + <Key: Hashable, Value>(lhs: [Key:Value], rhs: [Key:Value]) -> [Key:Value] {
	return lhs.withEntries(rhs)
}
