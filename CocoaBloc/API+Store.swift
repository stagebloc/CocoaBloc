//
//  API+Store.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension API {
	
	public static func getStoreDashboard(accountID: Int) -> Endpoint<SBStoreDashboard> {
		return Endpoint(
			path: "account/\(accountID)/store/dashboard",
			method: .GET)
	}
	
	public static func getOrders(accountID: Int) -> Endpoint<[SBOrder]> {
		return Endpoint(
			path: "account/\(accountID)/store/orders",
			method: .GET)
	}
	
	public static func setOrderShipped(
		orderID: Int,
		accountID: Int,
		trackingNumber: String,
		carrier: String) -> Endpoint<SBOrder> {
		return Endpoint(
			path: "account/\(accountID)/store/orders/\(orderID)",
			method: .POST,
			parameters: [
				"tracking_number": trackingNumber,
				"carrier": carrier
			])
	}
	
	public static func getStoreItemsForAccount(accountID: Int) -> Endpoint<[SBStoreItem]> {
		return Endpoint(
			path: "account/\(accountID)/store/items",
			method: .GET)
	}
	
	public static func getStoreItem(storeItemID: Int, accountID: Int) -> Endpoint<SBStoreItem> {
		return Endpoint(
			path: "account/\(accountID)/store/items/\(storeItemID)",
			method: .GET)
	}
}
