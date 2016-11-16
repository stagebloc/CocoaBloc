//
//  API+Account.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

extension API {
	
	public static func createAccount(
		name name: String,
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
		withIdentifier accountID: Int,
		name: String?,
		description: String?,
		url: String?,
		type: AccountType?,
		color: AccountColor?) -> Endpoint<Account> {
		precondition(
			name != nil || description != nil || url != nil || type != nil || color != nil,
			"You can only create an update account endpoint with something to update"
		)
		
		return Endpoint(
			path: "account/\(accountID)",
			method: .POST,
			parameters: [
				"name"          : name,
				"description"   : description,
				"stagebloc_url" : url,
				"type"          : type?.rawValue,
				"color"         : color?.rawValue
			].filterEntriesWithNilValues()
		)
	}
	
	public static func updateImageForAccount(
		withIdentifier accountID: Int,
		               formData: FormDataPart) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)",
			method: .POST,
			formData: [formData])
	}
	
	public static func followAccount(withIdentifier accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .POST,
			keyPath: "data.account")
	}
	
	public static func unfollowAccount(withIdentifier accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "/account/\(accountID)/follow",
			method: .DELETE,
			keyPath: "data.account")
	}
	
	// Set admin to true to get accounts youre an admin of, otherwise gets accounts you're following.
	public enum UserAccountType {
		case admin
		case following
	}
	public static func getAuthenticatedUserAccounts(forType type: UserAccountType) -> Endpoint<[Account]> {
		return Endpoint(
			path: "accounts",
			method: .GET,
			parameters: [
				"admin"		: type == .admin ? 1:0,
				"following"	: type == .following ? 1:0
			])
	}
	
	public static func getAccount(withIdentifier accountID: Int) -> Endpoint<Account> {
		return Endpoint(
			path: "account/\(accountID)",
			method: .GET)
	}

}
