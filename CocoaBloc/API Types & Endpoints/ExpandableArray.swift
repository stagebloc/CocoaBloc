//
//  ExpandableArray.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/25/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Runes

public enum ExpandableArray<Item> where
	Item: Decodable,
	Item.DecodedType == Item {
	
	case unexpanded(count: Int)
	indirect case expanded([Item])
	
	public var value: [Item]? {
		if case .expanded(let value) = self {
			return value
		}
		return nil
	}
	
	public var count: Int {
		switch self {
		case .unexpanded(let count):
			return count
		case .expanded(let value):
			return value.count
		}
	}
	
}

extension ExpandableArray: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<ExpandableArray<Item>> {
		switch json {
		case .number(let number as Int):
			return pure(.unexpanded(count: number))
		case .array:
			return ExpandableArray.expanded <^> [Item].decode(json)
		default:
			return .typeMismatch(expected: "Expandable array", actual: json)
		}
	}
	
}
