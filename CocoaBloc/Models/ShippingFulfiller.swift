//
//  ShippingFulfiller.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct ShippingFulfiller: Decodable, Identifiable {
	
	public let identifier: Int
	public let type: Int
	public let name: String
	public let address: Address?
	public let priceHandlers: [ShippingPriceHandler]
	
	public static func decode(json: JSON) -> Decoded<ShippingFulfiller> {
		return curry(ShippingFulfiller.init)
			<^> json <| "id"
			<*> json <| "type"
			<*> json <| "name"
			<*> json <|? "address"
			<*> json <|| "shipping_price_handlers" <|> pure([])
	}
	
}
