//
//  Cart+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Cart: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Cart> {
		let a = curry(Cart.init)
			<^> json <| "id"
			<*> json <| "user_id"
			<*> json <|? "user"
			<*> json <| "session_id"
			<*> json <| "created"
		return a
			<*> json <|? "email"
			<*> json <| "status"
			<*> json <|| "cart_items" <|> pure([])
			<*> json <|? "shipping_address"
			<*> json <| "totals"
	}
	
}

extension Cart.Item: Decodable {

	public static func decode(json: JSON) -> Decoded<Cart.Item> {
		let a = curry(Cart.Item.init)
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

extension Cart.Totals: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Cart.Totals> {
		return curry(Cart.Totals.init)
			<^> json <| "items"
			<*> json <| "subtotal"
			<*> json <| "total"
			<*> json <| "shipping"
	}
	
}

extension Cart.Status: Decodable { }
