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
	
	case Unexpanded(count: Int)
	indirect case Expanded([Item])
	
	public var value: [Item]? {
		if case .Expanded(let value) = self {
			return value
		}
		return nil
	}
	
	public var count: Int {
		switch self {
		case .Unexpanded(let count):
			return count
		case .Expanded(let value):
			return value.count
		}
	}
}

extension ExpandableArray: Decodable {
	public static func decode(json: JSON) -> Decoded<ExpandableArray<Item>> {
		switch json {
		case .Number(let number as Int):
			return pure(.Unexpanded(count: number))
		case .Array:
			return Array<Item>.decode(json).map { .Expanded($0) }
		default:
			return .typeMismatch("Expandable array", actual: json)
		}
	}
}
