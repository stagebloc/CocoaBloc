//
//  Expandable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo

public enum Expandable<Item where Item: Decodable, Item.DecodedType: Identifiable> {
	
	typealias Identifier = Item.DecodedType.Identifier
	
	case Unexpanded(identifier: Identifier)
	indirect case Expanded(Item.DecodedType)
	
	public var identifier: Identifier {
		switch self {
		case .Unexpanded(let identifier):
			return identifier
		case .Expanded(let item):
			return item.identifier
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
