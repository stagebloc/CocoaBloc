//
//  ExpandableArray.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/25/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo

public enum ExpandableArray<Item where
	Item: Decodable,
	Item.DecodedType: Identifiable,
	Item.DecodedType == Item> {
	
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
	public static func decode(json: JSON) -> Decoded<ExpandableArray<Item>> {
		switch json {
		case .Number(let number as Int):
			return pure(.unexpanded(count: number))
		case .Array:
			return Array<Item>.decode(json).map { .expanded($0) }
		default:
			return .typeMismatch("Expandable array", actual: json)
		}
	}
}
