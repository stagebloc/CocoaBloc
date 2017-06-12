//
//  Expandable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Runes

public enum Expandable<Item> where
	Item: Argo.Decodable,
	Item.DecodedType: Identifiable,
	Item.DecodedType == Item {
	
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

extension Expandable: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Expandable<Item>> {
		switch json {
		case .number(let number as Int):
			return pure(.unexpanded(identifier: number))
		case .object, .array:
			return Expandable.expanded <^> Item.decode(json)
		default:
			return .typeMismatch(expected: "Unexpanded identifier -OR- expanded object/array", actual: json)
		}
	}
	
}
