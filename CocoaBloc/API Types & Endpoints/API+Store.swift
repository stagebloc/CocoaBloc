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
	
	public static func getCart(withIdentifier cartSessionID: String) -> Endpoint<Cart> {
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
	
	public static func updateCart(withIdentifier sessionID: String,
	                                             newEmail: String?,
	                                             newShippingAddress: Address?) -> Endpoint<Cart> {
		precondition(
			newEmail != nil || newShippingAddress != nil,
			"Can't create an endpoint to update nothing on the cart."
		)
		return Endpoint(
			path: "cart/\(sessionID)",
			method: .POST,
			parameters: [
				"cart": [
					"session_id": sessionID,
					"email": newEmail,
					//				"addresses": newAddresses
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
