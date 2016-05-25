//
//  Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct Address: Decodable, Identifiable {
	
	public let identifier: Int
	public let name: String
	public let streetAddress: String
	public let streetAddress2: String
	public let city: String
	public let state: String
	public let postalCode: String
	public let country: String
	
	public static func decode(json: JSON) -> Decoded<Address> {
		return curry(Address.init)
			<^> json <| "id"
			<*> json <| "name"
			<*> json <| "street_address"
			<*> json <| "street_address_2"
			<*> json <| "city"
			<*> json <| "state"
			<*> json <| "postal_code"
			<*> json <| "country"
	}
}
