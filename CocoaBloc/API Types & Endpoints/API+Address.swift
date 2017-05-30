//
//  API+Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

extension API {
	
	public enum AddressType: String {
		case shipping				= "shipping"
		case inactiveShipping		= "inactive-shipping"
		case location				= "location"
		case oneTimeShipping		= "one-time-shipping"
		case paymentVerification	= "payment-verification"
		case billing				= "billing"
	}

	public static func getAddress(withIdentifier addressID: Int) -> Endpoint<Address> {
		return Endpoint(path: "users/me/addresses/\(addressID)", method: .get)
	}

	public static func getAllAddresses(forType type: AddressType) -> Endpoint<Addresses> {
		return Endpoint(path: "users/me/addresses/\(type)", method: .get)
	}
	
	public static func createAddress(withType type: AddressType, newShippingAddress: Address) -> Endpoint<SingleAddress> {
		return Endpoint(
			path: "users/me/addresses/\(type)",
			method: .post,
			parameters: [
					"address": [
						"name": newShippingAddress.name,
						"street_address": newShippingAddress.streetAddress,
						"street_address_2": newShippingAddress.streetAddress2,
						"city": newShippingAddress.city,
						"state": newShippingAddress.state,
						"postal_code": newShippingAddress.postalCode,
						"country": newShippingAddress.country
					]
				].filterEntriesWithNilValues()
			)
	}
	
	public static func updateAddress(withType type: AddressType, shippingAddress: Address) -> Endpoint<SingleAddress> {
		return Endpoint(
			path: "users/me/addresses/\(type)/\(shippingAddress.identifier ?? 0)",
			method: .post,
			parameters: [
				"address": [
					"name": shippingAddress.name,
					"street_address": shippingAddress.streetAddress,
					"street_address_2": shippingAddress.streetAddress2,
					"city": shippingAddress.city,
					"state": shippingAddress.state,
					"postal_code": shippingAddress.postalCode,
					"country": shippingAddress.country
				]
				].filterEntriesWithNilValues()
			)
	}
	
	public static func deleteAddress(withType type: AddressType, identifier: Int) -> Endpoint<SingleAddress> {
		return Endpoint(path: "users/me/addresses/\(type)/\(identifier)", method: .delete)
	}
	
}
