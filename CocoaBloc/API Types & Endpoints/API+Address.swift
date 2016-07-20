//
//  API+Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Foundation
import Alamofire

extension API {
	
	public enum AddressType: String {
		case shipping				= "shipping"
		case inactiveShipping		= "inactive-shipping"
		case location				= "location"
		case oneTimeShipping		= "one-time-shipping"
		case paymentVerification	= "payment-verification"
		case billing				= "billing"
	}

	public static func getAddress(withID addressID: Int) -> Endpoint<Address> {
		return Endpoint(path: "users/me/addresses/\(addressID)", method: .GET)
	}

	public static func getAllAddresses(forType type: AddressType) -> Endpoint<[Address]> {
		return Endpoint(path: "users/me/addresses/\(type)", method: .GET)
	}
	
	public static func createAddress(withType type: AddressType) -> Endpoint<Address> {
		return Endpoint(
			path: "users/me/addresses/\(type)",
			method: .POST,
			parameters: [
				:
			])
	}
	
	public static func updateAddress(withType type: AddressType, identifier: Int) -> Endpoint<Address> {
		return Endpoint(
			path: "users/me/addresses/\(type)/\(identifier)",
			method: .POST,
			parameters: [
				:
			])
	}
	
	public static func deleteAddress(withType type: AddressType, identifier: Int) -> Endpoint<Address> {
		return Endpoint(path: "users/me/addresses/\(type)\(identifier)", method: .DELETE)
	}
}
