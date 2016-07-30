//
//  Cart.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Cart: Identifiable {
	
	public struct Item: Identifiable {
		public let identifier: Int
		public let cartID: Int
		public let creationDate: NSDate
		public let hash: String
		public let productID: Int
		public let productType: String
		public let namedPrice: String
		public let quantity: Int
		//		public let details:
		public let status: String
		public let sku: String
		public let parentID: Int?
		public let lockExpires: NSDate
	}
	
	public struct Totals {
		public let items: Double
		public let subtotal: Double
		public let total: Double
		public let shipping: Double
	}
	
	public enum Status: String {
		case started			= "STARTED"
		case reachedCheckout	= "REACHED_CHECKOUT"
		case completedCheckout	= "COMPLETED_CHECKOUT"
	}
	
	public let identifier: Int
	public let userID: Int
//	public let user: User?
	public let sessionID: Int
	public let creationDate: NSDate
	public let emailAddress: String?
	public let status: Status
//	public let items: [Item]?
	public let shippingAddress: Expandable<Address>
	public let totals: Totals
//	public let shippingDetails:
//	public let shippingRates:
//	public let selectedShipping
	
}
