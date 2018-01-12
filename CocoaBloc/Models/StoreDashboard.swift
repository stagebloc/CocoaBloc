//
//  StoreDashboard.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2016-11-04.
//  Copyright © 2016 StageBloc. All rights reserved.
//

public struct StoreDashboard: Codable {
	
	public let kind: String
	public let totals: Totals
	public let revenue: Revenue
	public let averages: Averages
	
	public struct Totals: Codable {
		public let revenue: Double
		public let shippingHandling: Double
		public let tax: Double
		public let orders: Int
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			guard let taxTest = try Double(values.decode(String.self, forKey: .tax)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.tax], debugDescription: "Expecting string representation of Double"))
			}
			tax = taxTest
			guard let shippingHandlingTest = try Double(values.decode(String.self, forKey: .shippingHandling)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.shippingHandling], debugDescription: "Expecting string representation of Double"))
			}
			shippingHandling = shippingHandlingTest
			guard let revenueTest = try Double(values.decode(String.self, forKey: .revenue)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.revenue], debugDescription: "Expecting string representation of Double"))
			}
			revenue = revenueTest
			orders = try values.decode(Int.self, forKey: .orders)
		}
	}
	
	public struct Revenue: Codable {
		public let store: Double
		public let fanClub: Double
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			guard let storeTest = try Double(values.decode(String.self, forKey: .store)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.store], debugDescription: "Expecting string representation of Double"))
			}
			store = storeTest
			guard let fanClubTest = try Double(values.decode(String.self, forKey: .fanClub)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.fanClub], debugDescription: "Expecting string representation of Double"))
			}
			fanClub = fanClubTest
		}
	}
	
	public struct Averages: Codable {
		public let orderPrice: Double
		public let fanValue: Double
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			guard let orderPriceTest = try Double(values.decode(String.self, forKey: .orderPrice)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.orderPrice], debugDescription: "Expecting string representation of Double"))
			}
			orderPrice = orderPriceTest
			guard let fanValueTest = try Double(values.decode(String.self, forKey: .fanValue)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.fanValue], debugDescription: "Expecting string representation of Double"))
			}
			fanValue = fanValueTest
		}
	}
	
}

private struct PostCancelOrder: Codable {
	public let adjust_stock: Bool
	public let alert_user: Bool
	public let refund_reason: String
	public let refund_reason_text: String
}

extension Client {
	
	public func getStoreDashboard(_ accountID: Int, completionHandler: @escaping (Result<StoreDashboard, APIError>) -> Void) {
		get(withEndPoint: "account/\(accountID)/store/dashboard", completionHandler: completionHandler)
	}
	
	public func getOrdersForAccount(withIdentifier accountID: Int, offset: Int = 0, limit: Int = 50, useCache: Bool = true, completionHandler: @escaping (Result<[Order], APIError>) -> Void) {
		let params = [
			"offset": offset,
			"limit": limit,
			"expand": "account"
			] as [String : Any]
		get(withEndPoint: "account/\(accountID)/store/order", params: params, useCache: useCache, completionHandler: completionHandler)
	}
	
	public func resendReceipt(withIdentifier orderID: Int, accountIdentifier accountID: Int, completionHandler: @escaping (Result<Bool, APIError>) -> Void) {
		post(withEndPoint: "account/\(accountID)/order/\(orderID)/receipt/resend", completionHandler: completionHandler)
	}
	
	public func cancelOrder(withIdentifier orderID: Int, accountIdentifier accountID: Int, adjustStock: Bool = false, alertUser: Bool = false, reasonCode: String = "good_will", reasonText: String = "Checkout App Return", completionHandler: @escaping (Result<Bool, APIError>) -> Void) {
		let postCancel = PostCancelOrder(adjust_stock: adjustStock, alert_user: alertUser, refund_reason: reasonCode, refund_reason_text: reasonText)
		
		do {
			let encoder = JSONEncoder()
			let postCancelJSON = try encoder.encode(postCancel)
			post(withEndPoint: "account/\(accountID)/store/order/\(orderID)/refund", postJSON: postCancelJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(.failure(.system("Failed to encode request to JSON")))
		}
	}
	
//	public static func setOrderShipped(
//		withIdentifier orderID: Int,
//		accountIdentifier accountID: Int,
//		trackingNumber: String,
//		carrier: String) -> Endpoint<Order> {
//		return Endpoint(
//			path: "account/\(accountID)/store/order/\(orderID)",
//			method: .post,
//			parameters: [
//				"tracking_number": trackingNumber,
//				"carrier": carrier
//			])
//	}
	
	public func getStoreItemsForAccount(withIdentifier accountID: Int, offset: Int = 0, limit: Int = 50, useCache: Bool = true, completionHandler: @escaping (Result<[StoreItem], APIError>) -> Void) {
		let params = [
			"offset": offset,
			"limit": limit,
			"expand": "photo,photos"
		] as [String : Any]
		get(withEndPoint: "account/\(accountID)/store/items", params: params, useCache: useCache, completionHandler: completionHandler)
	}
	
	public func getStoreItem(withIdentifier storeItemID: Int, forAccountWithIdentifier accountID: Int, completionHandler: @escaping (Result<StoreItem, APIError>) -> Void) {
		get(withEndPoint: "account/\(accountID)/store/items/\(storeItemID)", completionHandler: completionHandler)
	}
}
