//
//  ShippingMethod.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/20/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct ShippingMethod: Decodable, Identifiable {
	public let identifier: Int
	public let price: Double
	public let handlingPrice: Double
	
	public static func decode(json: JSON) -> Decoded<ShippingMethod> {
		return curry(ShippingMethod.init)
			<^> json <| "identifier"
			<*> json <| "price"
			<*> json <| "handling"
	}
}
