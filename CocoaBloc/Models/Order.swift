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
	public let receiptURL: NSURL
	public let orderDate: NSDate
	public let isShipped: Bool
	public let currency: StoreItem.Currency
	public let total: Double
	public let totalUSD: Double
	public let shippingAmount: Double
	public let handlingAmount: Double
	public let taxAmount: Double
	public let status: String
	public let notes: String
	public let emailAddress: String
	public let user: User?
	public let address: Address
	public let transactions: [Transaction]
	
	public struct Shipment: Identifiable {
		
		public let identifier: Int
		public let trackingNumber: String
		public let shippedDate: NSDate
				
	}
	
	public struct Transaction: Identifiable {
		
		public let identifier: Int
		public let modificationDate: NSDate
		public let amount: Double
		public let status: String
		public let quantity: Int
		public let shipment: Order.Shipment?
				
	}
	
}
