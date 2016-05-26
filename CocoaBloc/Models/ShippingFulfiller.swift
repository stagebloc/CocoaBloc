//
//  ShippingFulfiller.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct ShippingFulfiller: Decodable, Identifiable {
	
	public let identifier: Int
	public let type: String
	public let name: String
	
	public static func decode(json: JSON) -> Decoded<ShippingFulfiller> {
		return curry(ShippingFulfiller.init)
			<^> json <| "id"
			<*> json <| "type"
			<*> json <| "name"
	}
}