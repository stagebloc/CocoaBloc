//
//  Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Address {
	
	public let identifier: Int?
	public let name: String
	public let streetAddress: String
	public let streetAddress2: String
	public let city: String
	public let state: String
	public let postalCode: String
	public let country: String
	
	public init(identifier: Int? = nil, name: String = "", streetAddress: String, streetAddress2: String = "", city: String, state: String, postalCode: String, country: String) {
		self.identifier = identifier
		self.name = name
		self.streetAddress = streetAddress
		self.streetAddress2 = streetAddress2
		self.city = city
		self.state = state
		self.postalCode = postalCode
		self.country = country
	}
}

public struct Addresses {
	public let addresses: [Address]
}
