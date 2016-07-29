//
//  Transaction.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Transaction: Decodable, Identifiable {
	
	public let identifier: Int
	public let modificationDate: NSDate
	public let amount: Double
	public let status: String
	public let quantity: Int
	public let shipment: OrderShipment?
	
	public static func decode(json: JSON) -> Decoded<Transaction> {
		return curry(Transaction.init)
			<^> json <| "id"
			<*> json <| "modified"
			<*> json <| "amount"
			<*> json <| "status"
			<*> json <| "quantity"
			<*> json <|? "shipment"
	}
}
