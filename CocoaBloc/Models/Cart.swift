//
//  Cart.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Cart: Identifiable, Decodable {
	
	public struct Item: Identifiable, Decodable {
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
		public let lockExpires: Int
		
		public static func decode(json: JSON) -> Decoded<Item> {
			let a = curry(Item.init)
				<^> json <| "id"
				<*> json <| "cart"
				<*> json <| "created"
				<*> json <| "hash"
				<*> json <| "product_id"
				<*> json <| "product_type"
				<*> json <| "named_price"
			return a
				<*> json <| "quantity"
				<*> json <| "status"
				<*> json <| "sku"
				<*> json <|? "parent_id"
				<*> json <| "lock_expires"
		}
	}
	
	public struct Totals: Decodable {
		public let items: Double
		public let subtotal: Double
		public let total: Double
		public let shipping: Double
		
		public static func decode(json: JSON) -> Decoded<Totals> {
			return curry(Totals.init)
				<^> json <| "items"
				<*> json <| "subtotal"
				<*> json <| "total"
				<*> json <| "shipping"
		}
	}
	
	public enum Status: String, Decodable {
		case started = "STARTED"
		case reachedCheckout = "REACHED_CHECKOUT"
		case completedCheckout = "COMPLETED_CHECKOUT"
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
	
	public static func decode(json: JSON) -> Decoded<Cart> {
		return curry(Cart.init)
			<^> json <| "id"
			<*> json <| "user_id"
			<*> json <| "session_id"
			<*> json <| "created"
			<*> json <|? "email"
			<*> json <| "status"
			<*> json <| "shipping_address"
			<*> json <| "totals"
	}
	
}
