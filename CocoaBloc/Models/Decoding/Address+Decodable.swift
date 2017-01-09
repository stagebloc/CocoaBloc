//
//  Address+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension Address: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Address> {
		return curry(Address.init)
			<^> json <|? "id"
			<*> json <| "name"
			<*> json <| "street_address"
			<*> json <| "street_address_2"
			<*> json <| "city"
			<*> json <| "state"
			<*> json <| "postal_code"
			<*> json <| "country"
	}
	
}

extension Addresses: Decodable {
	public static func decode(_ json: JSON) -> Decoded<Addresses> {
		return curry(Addresses.init)
			<^> json <|| "addresses"
	}
}

extension SingleAddress: Decodable {
	public static func decode(_ json: JSON) -> Decoded<SingleAddress> {
		return curry(SingleAddress.init)
			<^> json <| "address"
	}
}
