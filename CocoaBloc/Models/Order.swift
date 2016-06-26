//
//  Order.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct Order: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let receiptURL: NSURL
	public let isOrdered: Bool
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
	public let user: User
	public let address: Address
	public let transactions: [Transaction]
	
	public static func decode(json: JSON) -> Decoded<Order> {
		let a = curry(Order.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "receipt_url"
			<*> json <| "ordered"
			<*> json <| "shipped"
			<*> json <| "currency"
		let b = a
			<*> json <| "total"
			<*> json <| "total_usd"
			<*> json <| "shipping_amount"
			<*> json <| "handling_amount"
			<*> json <| "tax_amount"
			<*> json <| "status"
		return b
			<*> json <| "notes"
			<*> json <| "email"
			<*> json <| "user"
			<*> json <| "address"
			<*> json <|| "transactions"
	}
}
