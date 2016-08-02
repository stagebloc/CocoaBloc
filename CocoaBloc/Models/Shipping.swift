//
//  Shipping.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public enum Shipping {
	
	public struct PriceHandler: Identifiable {
		public let identifier: Int
		public let name: String
		public let price: Double
		public let shippingMethods: [Method]
	}

	public struct Method: Identifiable {
		public let identifier: Int
		public let price: Double
		public let handlingPrice: Double
	}

	public struct Fulfiller: Identifiable {
		public let identifier: Int
		public let type: Int
		public let name: String
		public let address: Address?
		public let priceHandlers: [PriceHandler]
	}
	
	public struct RateSet {
		public let orderFulfillers: [Fulfiller]
		public let preorderFulfillers: [Fulfiller]
	}
	
	public struct Selection {
		public let fulfillerID: Int
		public let handlerID: Int
		public let methodID: Int
		public let price: Double
		public let handlingPrice: Double
	}
	
	public struct SelectionSet {
		public let orderSelection: Selection
		public let preorderSelection: Selection?
	}
	
	
	
}
