//
//  Expandable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo

public enum Expandable<Item where
	Item: Decodable,
	Item.DecodedType: Identifiable,
	Item.DecodedType == Item> {
	
	case unexpanded(identifier: Int)
	indirect case expanded(Item)
	
	public var value: Item? {
		if case .expanded(let value) = self {
			return value
		}
		return nil
	}
	
	public var identifier: Int {
		switch self {
		case .unexpanded(let identifier):
			return identifier
		case .expanded(let value):
			return value.identifier
		}
	}
	
}

extension Expandable: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Expandable<Item>> {
		switch json {
		case .Number(let number as Int):
			return pure(.unexpanded(identifier: number))
		case .Object, .Array:
			return Expandable.expanded <^> Item.decode(json)
		default:
			return .typeMismatch("Unexpanded identifier -OR- expanded object/array", actual: json)
		}
	}
	
}
