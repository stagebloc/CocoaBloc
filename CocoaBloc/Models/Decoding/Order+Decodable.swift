//
//  Order+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Order: Decodable {
	
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
			<*> json <|? "user"
			<*> json <| "address"
			<*> json <|| "transactions"
	}

}

extension Order.Shipment: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Order.Shipment> {
		return curry(Order.Shipment.init)
			<^> json <| "id"
			<*> json <| "tracking_number"
			<*> json <| "shipped"
	}

}

extension Order.Transaction: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Order.Transaction> {
		let item: Decoded<Order.Item> = decodedJSON(json, forKey: "item").flatMap(Order.Item.decode)
		return curry(Order.Transaction.init)
			<^> json <| "id"
			<*> json <| "modified"
			<*> json <| "amount"
			<*> json <| "status"
			<*> json <| "quantity"
			<*> json <|? "shipment"
			<*> item
	}

}

extension Order.Item: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Order.Item> {
		let object: Decoded<StoreItem> = decodedJSON(json, forKey: "object").flatMap(StoreItem.decode)
		return curry(Order.Item.init)
			<^> json <| "type"
			<*> object
	}
}
