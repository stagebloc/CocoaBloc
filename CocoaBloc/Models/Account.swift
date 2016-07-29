//
//  Account.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Argo
import Curry

public struct Account: Decodable, Identifiable {
	
	public let identifier: Int
	public let url: NSURL?
	public let stageBlocURL: NSURL
	public let name: String
	public let descriptiveText: String
//	public let type: API.AccountType
	public let isStripeEnabled: Bool
	public let isVerified: Bool
	public let photo: AccountPhoto?
	public let color: RGBComponents
	
	public static func decode(json: JSON) -> Decoded<Account> {
		return curry(Account.init)
			<^> json <| "id"
			<*> json <|? "url"
			<*> json <| "stagebloc_url"
			<*> json <| "name"
			<*> json <| "description"
//			<*> json <| "type"
			<*> json <| "stripe_enabled"
			<*> json <| "verified"
			<*> json <|? "photo"
			<*> json <| "color"
	}
}
