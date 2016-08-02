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
