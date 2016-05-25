//
//  OrderShipment.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct OrderShipment: Decodable, Identifiable {
	
	public let identifier: Int
	public let trackingNumber: String
	public let shipped: Bool
	
	public static func decode(json: JSON) -> Decoded<OrderShipment> {
		return curry(OrderShipment.init)
			<^> json <| "id"
			<*> json <| "tracking_number"
			<*> json <| "shipped"
	}
}