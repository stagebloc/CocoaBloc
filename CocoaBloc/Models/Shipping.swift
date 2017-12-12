//
//  Shipping.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Shipping: Codable {
	
	public struct PriceHandler: APIObject {
		public let id: Int
		public let shippingMethods: [Method]?
		
		private enum CodingKeys: String, CodingKey {
			case id, shippingMethods = "shipping_methods"
		}
	}

	public struct Method: APIObject {
		public let id: Int
		public let name: String
		public let price: Double
		public let handlingPrice: Double
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			id = try values.decode(Int.self, forKey: .id)
			name = try values.decode(String.self, forKey: .name)
			price = try round(values.decode(Double.self, forKey: .price) * 100.0) / 100.0
			handlingPrice = try round(values.decode(Double.self, forKey: .handlingPrice) * 100.0) / 100.0
		}
		
		private enum CodingKeys: String, CodingKey {
			case id, name, price, handlingPrice = "handling"
		}
	}

	public struct Fulfiller: APIObject {
		public let id: Int
		public let type: Int
		public let name: String
		public let address: Address?
		public let shippingPriceHandlers: [PriceHandler]?
		
		private enum CodingKeys: String, CodingKey {
			case id, type, name, address, shippingPriceHandlers = "shipping_price_handlers"
		}
	}
	
	public struct RateSet: Codable {
		public struct FulfillerHolder: Codable {
			public let fulfillers: [Fulfiller]
		}
		public let order: FulfillerHolder?
		public let preorder: FulfillerHolder?
	}
	
	public struct Selection: Codable {
		public let fulfillerID: Int
		public let handlerID: Int
		public let methodID: Int
		public let price: Double
		public let handlingPrice: Double
		
		public init(fulfillerID: Int, handlerID: Int, methodID: Int, price: Double, handlingPrice: Double) {
			self.fulfillerID = fulfillerID
			self.handlerID = handlerID
			self.methodID = methodID
			self.price = price
			self.handlingPrice = handlingPrice
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			fulfillerID = try values.decode(Int.self, forKey: .fulfillerID)
			handlerID = try values.decode(Int.self, forKey: .handlerID)
			methodID = try values.decode(Int.self, forKey: .methodID)
			price = try values.decode(Double.self, forKey: .price)
			handlingPrice = try values.decode(Double.self, forKey: .handlingPrice)
		}
		
		private enum CodingKeys: String, CodingKey {
			case fulfillerID = "fulfiller_id", handlerID = "price_handler_id", methodID = "method_id", price, handlingPrice = "handling"
		}
	}
	
	public struct SelectionSet: Codable {
//		public struct SelectionHolder: Codable {
//			public let fulfillers: [Fulfiller]
//		}
		public let order: [Selection]
		public let preorder: [Selection]?
	}
	
}
