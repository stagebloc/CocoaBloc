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
		color: AccountColor) -> Endpoint<Account> {
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
		color: AccountColor?) -> Endpoint<Account> {
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
	                                      formData: FormDataPart) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)",
			method: .POST,
			formData: [formData])
	}
	
	public static func followAccount(accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .POST,
			keyPath: "account")
	}
	
	public static func unfollowAccount(accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .DELETE,
			keyPath: "account")
	}
	
	// Set admin to true to get accounts youre an admin of, otherwise gets accounts you're following.
	public static func getAuthenticatedUserAccounts(admin: Bool = false) -> Endpoint<[Account]> {
		return Endpoint(
			path: "accounts",
			method: .GET,
			parameters: [
				"admin"		:	admin,
				"following"	:	!admin
			])
	}
	
	public static func getAccount(accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "account/\(accountID)",
			method: .GET)
	}
}
