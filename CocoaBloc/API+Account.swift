//
//  API+Account.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension API {
	
	public static func createAccount(
		name: String,
		description: String,
		url: String,
		type: AccountType,
		color: AccountColor
	) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "account",
			method: .POST,
			parameters: [
				"name"          : name,
				"description"   : description,
				"stagebloc_url" : url,
				"type"          : type.rawValue,
				"color"         : color.rawValue
			])
	}
	
	public static func updateAccount(
		accountID: Int,
		name: String?,
		description: String?,
		url: String?,
		type: AccountType?,
		color: AccountColor?
		) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "account/\(accountID)",
			method: .POST,
			parameters: [
				"name"          : name,
				"description"   : description,
				"stagebloc_url" : url,
				"type"          : type?.rawValue,
				"color"         : color?.rawValue
				].filterNil())
	}
	
	public static func updateAccountImage(accountID: Int,
	                                      imageData: NSData) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "/account/\(accountID)",
			method: .POST,
			formData: [FormDataPart(title: "image", dataType: .Data(imageData))])
	}
	
	public static func followAccount(accountID: Int) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .POST,
			keyPath: "account")
	}
	
	public static func unfollowAccount(accountID: Int) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .DELETE,
			keyPath: "account")
	}
	
	public static func getAuthenticatedUserAccounts() -> Endpoint<[SBAccount]> {
		return Endpoint(
			path: "accounts",
			method: .GET)
	}
	
	public static func getAccount(accountID: Int) -> Endpoint<SBAccount> {
		return Endpoint(
			path: "account/\(accountID)",
			method: .GET)
	}
}
