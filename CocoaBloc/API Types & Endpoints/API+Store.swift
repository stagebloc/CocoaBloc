//
//  API+Store.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation

public struct StoreDashboard {
	
	public struct Totals {
		
	}
	
	public struct Revenue {
		
	}
	
	public struct Averages {
		
	}
	
}

extension API {
	
	public static func getStoreDashboard(accountID: Int) -> Endpoint<StoreDashboard> {
		return Endpoint(
			path: "account/\(accountID)/store/dashboard",
			method: .GET)
	}
	
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
	
	public static func deleteCartItem(
		withHash cartItemHash: String,
		fromCartWithIdentifier cartSessionID: Int) -> Endpoint<Cart> {
		return Endpoint(
			path: "cart/\(cartSessionID)/items/\(cartItemHash)",
			method: .DELETE)
	}
	
	//	public static func createCartItem(withSessionID sessionID: String)
	
	public static func getOrdersForAccount(withIdentifier accountID: Int) -> Endpoint<[Order]> {
		return Endpoint(
			path: "account/\(accountID)/store/orders",
			method: .GET)
	}
	
	public static func setOrderShipped(
		withIdentifier orderID: Int,
		accountIdentifier accountID: Int,
		                  trackingNumber: String,
		                  carrier: String) -> Endpoint<Order> {
		return Endpoint(
			path: "account/\(accountID)/store/orders/\(orderID)",
			method: .POST,
			parameters: [
				"tracking_number": trackingNumber,
				"carrier": carrier
			])
	}
	
	public static func getStoreItemsForAccount(withIdentifier accountID: Int) -> Endpoint<[StoreItem]> {
		return Endpoint(
			path: "account/\(accountID)/store/items",
			method: .GET)
	}
	
	public static func getStoreItem(
		withIdentifier storeItemID: Int,
		forAccountWithIdentifier accountID: Int) -> Endpoint<StoreItem> {
		return Endpoint(
			path: "account/\(accountID)/store/items/\(storeItemID)",
			method: .GET)
	}
	
}
