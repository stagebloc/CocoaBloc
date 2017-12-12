//
//  Expandable.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public enum Expandable<Item>: APIObject where Item: APIObject {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			let expanded = try container.decode(Item.self)
			self = .expanded(expanded)
		} catch {
			self = .unexpanded(identifier: try container.decode(Int.self))
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .expanded(let item):
			try container.encode(item)
		case .unexpanded(let identifier):
			try container.encode(identifier)
		}
	}

	case unexpanded(identifier: Int)
	indirect case expanded(Item)
		
	public var value: Item? {
		if case .expanded(let value) = self {
			return value
		}
		return nil
	}
		
	public var id: Int {
		switch self {
		case .unexpanded(let identifier):
			return identifier
		case .expanded(let value):
			return value.id
		}
	}
		
}

public enum ExpandableArray<Item>: Codable where Item: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			let expanded = try container.decode([Item].self)
			self = .expanded(expanded)
		} catch {
			self = .unexpanded(count: try container.decode(Int.self))
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .expanded(let items):
			try container.encode(items)
		case .unexpanded(let count):
			try container.encode(count)
		}
	}
	
	
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


