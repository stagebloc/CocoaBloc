//
//  API+Store.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation

extension API {
	
	public static func getStoreDashboard(_ accountID: Int) -> Endpoint<StoreDashboard> {
		return Endpoint(
			path: "account/\(accountID)/store/dashboard",
			method: .get)
	}
	
	public static func getOrdersForAccount(withIdentifier accountID: Int) -> Endpoint<[Order]> {
		return Endpoint(
			path: "account/\(accountID)/store/orders",
			method: .get)
	}
	
	public static func resendReceipt(
		withIdentifier orderID: Int,
		accountIdentifier accountID: Int) -> Endpoint<()> {
		return Endpoint(
			path: "account/\(accountID)/store/orders/\(orderID)/receipt/resend",
			method: .post)
	}
	
	public static func setOrderShipped(
		withIdentifier orderID: Int,
		accountIdentifier accountID: Int,
		                  trackingNumber: String,
		                  carrier: String) -> Endpoint<Order> {
		return Endpoint(
			path: "account/\(accountID)/store/orders/\(orderID)",
			method: .post,
			parameters: [
				"tracking_number": trackingNumber,
				"carrier": carrier
			])
	}
	
	public static func getStoreItemsForAccount(withIdentifier accountID: Int, limit: Int = 99999) -> Endpoint<[StoreItem]> {
		return Endpoint(
			path: "account/\(accountID)/store/items",
			method: .get,
			parameters: [
				"limit": limit
			])
	}
	
	public static func getStoreItem(
		withIdentifier storeItemID: Int,
		forAccountWithIdentifier accountID: Int) -> Endpoint<StoreItem> {
		return Endpoint(
			path: "account/\(accountID)/store/items/\(storeItemID)",
			method: .get)
	}
	
}
