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
		var selected_shippings:Decoded<[Shipping.Selection]> = decodedJSON(json, forKey: "shipping_selected").flatMap { shippingJson in
			return decodedJSON(shippingJson, forKey: "order").flatMap { itemsJson in
				switch itemsJson {
				case .Object(let jsonItemsMap):
					let ts = sequence(jsonItemsMap.values.map(Shipping.Selection.decode))
					return ts//sequence(jsonItemsMap.values.map(Shipping.Selection.decode))
				default:
					return pure([])
				}
			}
		}
		if case .Failure = selected_shippings {
			selected_shippings = pure([])
		}
		let a = curry(Cart.init)
			<^> json <| "id"
			<*> json <| "user_id"
			<*> json <|? "user"
			<*> json <| "session_id"
			<*> json <| "created"
		return a
			<*> json <|? "email"
			<*> json <| "status"
			<*> decodedJSON(json, forKey: "cart_items").flatMap { itemsJson in
				switch itemsJson {
				case .Object(let jsonItemsMap):
					return sequence(jsonItemsMap.values.map(Item.decode))
				default:
					return pure([])
				}
			}
			<*> json <|? "shipping_address"
			<*> json <| "totals"
			<*> json <|? "shipping_rates"
			<*> selected_shippings
	}
	
}

extension Cart.Item: Decodable {

	public static func decode(json: JSON) -> Decoded<Cart.Item> {
		let a = curry(Cart.Item.init)
			<^> json <| "id"
			<*> json <| "cart"
			<*> json <| "created"
			<*> json <| "hash"
			<*> json <| ["product", "id"]
			<*> json <| ["product", "type"]
			<*> json <|? "named_price"
		return a
			<*> json <| "quantity"
			<*> json <| "status"
			<*> json <| "sku"
			<*> json <|? "parent_id"
			<*> json <|? "lock_expires"
	}
	
}

extension Cart.Totals: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Cart.Totals> {
		return curry(Cart.Totals.init)
			<^> json <| "items"
			<*> json <| "subtotal"
			<*> json <| "total"
			<*> json <| "shipping"
			<*> json <|? "taxes"
	}
	
}

extension Cart.Status: Decodable { }
