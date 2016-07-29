//
//  Shipping.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct ShippingPriceHandler: Decodable, Identifiable {
	
	public let identifier: Int
	public let name: String
	public let price: Double
	public let shippingMethods: [ShippingMethod]
	
	public static func decode(json: JSON) -> Decoded<ShippingPriceHandler> {
		return curry(ShippingPriceHandler.init)
			<^> json <| "id"
			<*> json <| "name"
			<*> json <| "price"
			<*> json <|| "shipping_methods" <|> pure([])
	}
}
