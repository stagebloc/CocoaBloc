//
//  API+Cart.swift
//  CocoaBloc
//
//  Created by John Heaton on 8/2/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

extension API {
	
	public static func getCart(withSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(path: "cart/\(cartSessionID)", method: .GET)
	}
	
	public static func createCart(withEmail email: String? = nil, userID: Int? = nil, venue: Address? = nil) -> Endpoint<Cart> {
		if let _ = venue {
			return Endpoint(
				path: "cart",
				method: .POST,
				parameters: [
					"cart": [
						"email": email,
						"user_id": userID,
						"addresses": venue.map { address -> [String:AnyObject] in
							return [
								"shipping": [
									"name": address.name,
									"street_address": address.streetAddress,
									"street_address_2": address.streetAddress2,
									"city": address.city,
									"state": address.state,
									"postal_code": address.postalCode,
									"country": address.country
								]
							]
						}
					].filterEntriesWithNilValues()
				])
		} else {
			return Endpoint(
				path: "cart",
				method: .POST,
				parameters: [
					"cart": [
						"email": email,
						"user_id": userID
					].filterEntriesWithNilValues()
				])
		}
	}
	
	public static func updateCart(
		withSessionIdentifier cartSessionID: String,
		                      newEmail: String?,
		                      newShippingAddress: Address?) -> Endpoint<Cart> {
		if let identifier = newShippingAddress?.identifier {
			return Endpoint(
				path: "cart/\(cartSessionID)",
				method: .POST,
				parameters: [
					"cart": [
						"session_id": cartSessionID,
						"email": newEmail,
						"addresses": [
							"shipping_id": identifier
							].filterEntriesWithNilValues()
						].filterEntriesWithNilValues()
				])
		} else {
			return Endpoint(
				path: "cart/\(cartSessionID)",
				method: .POST,
				parameters: [
					"cart": [
						"session_id": cartSessionID,
						"email": newEmail,
						"addresses": newShippingAddress.map { address -> [String:AnyObject] in
							return [
								"shipping": [
									"name": address.name,
									"street_address": address.streetAddress,
									"street_address_2": address.streetAddress2,
									"city": address.city,
									"state": address.state,
									"postal_code": address.postalCode,
									"country": address.country
								]
							]
						}
						].filterEntriesWithNilValues()
				]
			)
		}
	}
	
	public static func updateCart(
		withSessionIdentifier cartSessionID: String,
		                      shippingInfo: Shipping.Selection,
		                      overrideShipping: Bool = false) -> Endpoint<Cart> {
		let shippingTitle = overrideShipping ? "shipping_override" : "shipping_details"
		return Endpoint(
			path: "cart/\(cartSessionID)",
			method: .POST,
			parameters: [
				"cart": [
					"session_id": cartSessionID,
//					"pickup_override": overrideShipping,
					shippingTitle: [
						"order": [[
							"fulfiller_id": shippingInfo.fulfillerID,
							"price_handler_id": shippingInfo.handlerID,
							"method_id": shippingInfo.methodID,
							"price": shippingInfo.price,
							"handling": shippingInfo.handlingPrice,
						]]
					]
				]
			])
	}
	
	public static func addItemToCart(
		withSessionIdentifier cartSessionID: String,
		storeItemIdentifier storeItemID: Int,
		                    sku: String,
		                    quantity: Int) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items",
			method: .POST,
			parameters: [
				"item": [
					"type": "store",
					"id": storeItemID,
					"sku": sku,
					"quantity": quantity
				]
			])
	}
	
	public static func updateItemInCart(
		withSessionIdentifier cartSessionID: String,
		                      storeItemID: Int,
		                      cartItemHash: String,
		                      sku: String?,
		                      quantity: Int?) -> Endpoint<Cart> {
		precondition(sku != nil || quantity != nil, "Must specify something to update on the cart item")
		
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .POST,
			parameters: [
				"item": [
					"type": "store",
					"id": storeItemID,
					"sku": sku,
					"quantity": quantity
				].filterEntriesWithNilValues()
			])
	}
	
	public static func deleteItemInCart(
		withHash cartItemHash: String,
		fromCartWithSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .DELETE)
	}
	
	public static func deleteAddressCart(
		withHash cartItemHash: String,
		         fromCartWithSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .DELETE)
	}
	
	public struct Payment {
		
		public enum PaymentType {
			case cash
			case giftCard
			case stripe(token: String)
		}
		
		public var type: PaymentType
		public var amount: Double
		
		private var json: [String:AnyObject] {
			var value: [String:AnyObject] = ["amount": amount]
			switch type {
			case .cash:
				value["payment_processor"] = "cash"
			case .giftCard:
				value["payment_processor"] = "gift_card"
			case .stripe(let token):
				value["payment_processor"] = "STRIPE"
				value["token"] = token
			}
			return value
		}
		
		public init(type: PaymentType, amount: Double) {
			self.type = type
			self.amount = amount
		}
		
	}
	
	public static func purchaseCart(
		withSessionIdentifier cartSessionID: String,
		                      payments: [Payment],
		                      tax: Double? = nil) -> Endpoint<[Order]> {
		if let tax = tax {
			return Endpoint(
				path: "cart/\(cartSessionID)/purchase",
				method: .POST,
				parameters: [
					"payments": payments.map { $0.json },
					"tax_override": tax
				])
		}
		return Endpoint(
			path: "cart/\(cartSessionID)/purchase",
			method: .POST,
			parameters: [
				"payments": payments.map { $0.json }
			])
	}
	
}
