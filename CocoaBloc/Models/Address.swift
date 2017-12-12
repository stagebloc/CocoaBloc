//
//  Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Address: APIObject {
	
	public let id: Int
	public let name: String?
	public let streetAddress: String?
	public let streetAddress2: String?
	public let city: String?
	public let state: String?
	public let postalCode: String?
	public let country: String?
	
	public init(id: Int = 0, name: String? = nil, streetAddress: String? = nil, streetAddress2: String? = nil, city: String? = nil, state: String? = nil, postalCode: String? = nil, country: String? = nil) {
		self.id = id
		self.name = name
		self.streetAddress = streetAddress
		self.streetAddress2 = streetAddress2
		self.city = city
		self.state = state
		self.postalCode = postalCode
		self.country = country
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, name, streetAddress = "street_address", streetAddress2 = "street_address_2", city, state, postalCode = "postal_code", country
	}
}

private struct PostAddress: Codable {
	public let address: Address
}

struct Addresses: Codable {
	public let addresses: [Address]?
}

extension Client {
	public func getAddress(withIdentifier addressID: Int, completionHandler: @escaping (Address?, Error?) -> Void) {
		get(withEndPoint: "users/me/addresses/\(addressID)", completionHandler: completionHandler)
	}
	
	public func getAllAddresses(forType type: AddressType, completionHandler: @escaping ([Address]?, Error?) -> Void) {
		get(withEndPoint: "users/me/addresses/\(type)") { (addresses: Addresses?, error: Error?) -> Void in
			guard error == nil else {
				completionHandler(nil, error)
				return
			}
			completionHandler(addresses?.addresses, error)
		}
	}
	
	public func createAddress(withType type: AddressType, newShippingAddress: Address, completionHandler: @escaping (Address?, Error?) -> Void) {
		let newAddress = PostAddress(address: newShippingAddress)
		
		do {
			let encoder = JSONEncoder()
			let newAddressJSON = try encoder.encode(newAddress)
			post(withEndPoint: "users/me/addresses/\(type)", postJSON: newAddressJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func updateAddress(withType type: AddressType, shippingAddress: Address, completionHandler: @escaping (Address?, Error?) -> Void) {
		let address = PostAddress(address: shippingAddress)
		
		do {
			let encoder = JSONEncoder()
			let addressJSON = try encoder.encode(address)
			post(withEndPoint: "users/me/addresses/\(type)", postJSON: addressJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func deleteAddress(withType type: AddressType, identifier: Int, completionHandler: @escaping (Address?, Error?) -> Void) {
		delete(withEndPoint: "users/me/addresses/\(type)/\(identifier)", completionHandler: completionHandler)
	}
	
	public enum AddressType: String {
		case shipping				= "shipping"
		case inactiveShipping		= "inactive-shipping"
		case location				= "location"
		case oneTimeShipping		= "one-time-shipping"
		case paymentVerification	= "payment-verification"
		case billing				= "billing"
	}
	
}
