//
//  Shipping+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Shipping.PriceHandler: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Shipping.PriceHandler> {
		return curry(Shipping.PriceHandler.init)
			<^> json <| "id"
//			<*> json <| "name"
//			<*> json <| "price"
			<*> json <|| "shipping_methods" <|> pure([])
	}

}

extension Shipping.Method: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Shipping.Method> {
		return curry(Shipping.Method.init)
			<^> json <| "id"
			<*> json <| "name"
			<*> json <| "price"
			<*> json <| "handling"
	}

}

extension Shipping.Fulfiller: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Shipping.Fulfiller> {
		return curry(Shipping.Fulfiller.init)
			<^> json <| "id"
			<*> json <| "type"
			<*> json <| "name"
			<*> json <|? "address"
			<*> json <|| "shipping_price_handlers" <|> pure([])
	}

}

extension Shipping.RateSet: Decodable {
	
	public static func decode(json: JSON) -> Decoded<Shipping.RateSet> {
		return curry(Shipping.RateSet.init)
			<^> json <|| ["order", "fulfillers"]
			<*> json <|| ["preorder", "fulfillers"] <|> pure([])
	}
	
}
