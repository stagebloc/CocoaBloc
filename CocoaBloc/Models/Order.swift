//
//  Order.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Order: Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let receiptURL: URL
	public let orderDate: Date
	public let isShipped: Bool
	public let currency: StoreItem.Currency
	public let total: Double
	public let totalUSD: Double
	public let shippingAmount: Double
	public let handlingAmount: Double
	public let taxAmount: Double
	public let status: String
	public let notes: String?
	public let emailAddress: String
	public let user: User?
	public let address: Address?
	public let transactions: [Transaction]
	
	public struct Shipment: Identifiable {
		public let identifier: Int
		public let trackingNumber: String
		public let shippedDate: Date
	}
	
	public struct Item {
		public let type: String
		public let object: StoreItem
	}
	
	public struct Transaction: Identifiable {
		public let identifier: Int
		public let modificationDate: Date
		public let amount: Double
		public let status: String
		public let quantity: Int
		public let shipment: Order.Shipment?
		public let item: Order.Item?
	}
	
}
