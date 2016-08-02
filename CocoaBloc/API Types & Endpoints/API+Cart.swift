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
	
	public static func createCart(withEmail email: String? = nil, userID: Int? = nil) -> Endpoint<Cart> {
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
	
	public static func updateCart(withSessionIdentifier cartSessionID: String,
	                                                    newEmail: String?,
	                                                    newShippingAddress: Address?) -> Endpoint<Cart> {
		precondition(
			newEmail != nil || newShippingAddress != nil,
			"Can't create an endpoint to update nothing on the cart."
		)
		return Endpoint(
			path: "cart/\(cartSessionID)",
			method: .POST,
			parameters: [
				"cart": [
					"session_id": cartSessionID,
					"email": newEmail,
					//				"addresses": newAddresses
				].filterEntriesWithNilValues()
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
		                      cartItemHash: String,
		                      sku: String?,
		                      quantity: Int?) -> Endpoint<Cart> {
		precondition(sku != nil || quantity != nil, "Must specify something to update on the cart item")
		
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .POST,
			parameters: [
				"item": [
					"sku": sku,
					"quantity": quantity
				].filterEntriesWithNilValues()
			])
	}
	
	public static func deleteItemInCart(
		withHash cartItemHash: String,
		fromCartWithSessionIdentifier cartSessionID: Int) -> Endpoint<Cart> {
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
				value["payment_processor"] = "stripe"
				value["token"] = token
			}
			return value
		}
		
	}
	
	public static func purchaseCart(
		withSessionIdentifier cartSessionID: String,
		                      payments: [Payment]) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/purchase",
			method: .POST,
			parameters: [
				"payments": payments.map { $0.json }
			])
	}
	
}
