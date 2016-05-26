//
//  Expandable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
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
		case .Bool: fallthrough
		case .Null: fallthrough
		case .String: fallthrough
		case .Object: fallthrough
		default:
			return .typeMismatch("Expandable array", actual: json)
		}
	}
}


public enum Expandable<Item where
	Item: Decodable,
	Item.DecodedType: Identifiable,
	Item.DecodedType == Item> {
	
	typealias Identifier = Item.DecodedType.Identifier
	
	case Unexpanded(identifier: Identifier)
	indirect case Expanded(Item)
	
	public var value: Item? {
		if case .Expanded(let value) = self {
			return value
		}
		return nil
	}
	
	public var identifier: Identifier {
		switch self {
		case .Unexpanded(let identifier):
			return identifier
		case .Expanded(let value):
			return value.identifier
		}
	}
}

extension Expandable: Decodable {
	public static func decode(json: JSON) -> Decoded<Expandable<Item>> {
		switch json {
		case .Number(let number as Item.DecodedType.Identifier):
			return pure(.Unexpanded(identifier: number))
		case .String(let string as Item.DecodedType.Identifier):
			return pure(.Unexpanded(identifier: string))
		case .Object:
			return Item.decode(json).map { .Expanded($0) }
		case .Array:
			return Item.decode(json).map { .Expanded($0) }
		case .Bool: fallthrough
		case .Null: fallthrough
		default:
			return .typeMismatch("Expandable object", actual: json)
		}
	}
}
