//
//  API+Cart.swift
//  CocoaBloc
//
//  Created by John Heaton on 8/2/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

extension API {
	
	public static func getCart(withSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(path: "cart/\(cartSessionID)", method: .get)
	}
	
	public static func createCart(withEmail email: String? = nil, userID: Int? = nil, venue: Address? = nil) -> Endpoint<Cart> {
		if let _ = venue {
			return Endpoint(
				path: "cart",
				method: .post,
				parameters: [
					"cart": [
						"email": email as Any,
						"user_id": userID as Any,
						"addresses": venue.map { address in
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
						} as Any
						].filterEntriesWithNilValues()
				])
		} else {
			return Endpoint(
				path: "cart",
				method: .post,
				parameters: [
					"cart": [
						"email": email as Any,
						"user_id": userID as Any
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
				method: .post,
				parameters: [
					"cart": [
						"session_id": cartSessionID,
						"email": newEmail as Any,
						"addresses": [
							"shipping_id": identifier
							].filterEntriesWithNilValues()
						].filterEntriesWithNilValues()
				])
		} else {
			return Endpoint(
				path: "cart/\(cartSessionID)",
				method: .post,
				parameters: [
					"cart": [
						"session_id": cartSessionID,
						"email": newEmail as Any,
						"addresses": newShippingAddress.map { address in
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
						} as Any
						].filterEntriesWithNilValues()
				]
			)
		}
	}
	
	public static func updateCart(
		withSessionIdentifier cartSessionID: String,
		                      shippingInfo: Shipping.Selection?,
		                      overrideShipping: Bool = false) -> Endpoint<Cart> {
		let shippingTitle = overrideShipping ? "shipping_override" : "shipping_details"
		if let shippingInfo = shippingInfo {
			return Endpoint(
				path: "cart/\(cartSessionID)",
				method: .post,
				parameters: [
					"cart": [
						"session_id": cartSessionID,
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
		return Endpoint(
			path: "cart/\(cartSessionID)",
			method: .post,
			parameters: [
				"cart": [
					"session_id": cartSessionID,
					shippingTitle: nil]
			])
	}
	
	public static func addItemToCart(
		withSessionIdentifier cartSessionID: String,
		storeItemIdentifier storeItemID: Int,
		                    sku: String,
		                    quantity: Int) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items",
			method: .post,
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
			method: .post,
			parameters: [
				"item": ([
					"type": "store",
					"id": storeItemID,
					"sku": sku as Any,
					"quantity": quantity as Any
				]).filterEntriesWithNilValues()
			])
	}
	
	public static func deleteItemInCart(
		withHash cartItemHash: String,
		fromCartWithSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .delete)
	}
	
	public static func deleteAddressCart(
		withHash cartItemHash: String,
		         fromCartWithSessionIdentifier cartSessionID: String) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .delete)
	}
	
	public struct Payment {
		
		public enum PaymentType {
			case cash
			case giftCard
			case stripe(token: String)
			case stripeCharge(id: String)
			case credit
		}
		
		public var type: PaymentType
		public var amount: Double
		
		fileprivate var json: [String:AnyObject] {
			var value: [String:AnyObject] = ["amount": amount as AnyObject]
			switch type {
			case .cash:
				value["payment_processor"] = "cash" as AnyObject?
			case .giftCard:
				value["payment_processor"] = "gift_card" as AnyObject?
			case .stripe(let token):
				value["payment_processor"] = "STRIPE" as AnyObject?
				value["token"] = token as AnyObject?
			case .stripeCharge(let id):
				value["payment_processor"] = "STRIPE" as AnyObject?
				value["charge_id"] = id as AnyObject?
			case .credit:
				value["payment_processor"] = "credit" as AnyObject?
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
		tax: Double? = nil,
		phone: String? = nil,
		deviceID: String = "",
		offline: Bool = false) -> Endpoint<[Order]> {
		var parameters: [String: Any] = ["payments": payments.map { $0.json }]
		if let tax = tax {
			parameters.updateValue(tax, forKey: "tax_override")
		}
		if let phone = phone {
			parameters.updateValue(phone, forKey: "phone_number")
		}
		return Endpoint(
			path: "cart/\(cartSessionID)/purchase",
			method: .post,
			parameters: parameters,
			header: ["x-application-device-identifier": deviceID,
			         "x-application-mode": offline ? "offline" : "online"])
	}
	
	public static func updateCoupon(
		withSessionIdentifier cartSessionID: String,
		coupon: String = "") -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)",
			method: .post,
			parameters: [
				"cart": [
					"session_id": cartSessionID,
					"coupon_code": [coupon]
				]
			])
	}
	
}
