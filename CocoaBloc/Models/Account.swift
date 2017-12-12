//
//  Account.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Account: APIObject {
	public struct CustomFields: Codable {
		public let autoFollow: String?
		public let restaurant: Bool?
		
		private enum CodingKeys: String, CodingKey {
			case autoFollow = "auto-follow", restaurant
		}
	}

	public let id: Int
	public let url: URL?
	public let stageBlocURL: URL
	public let name: String
	public let descriptiveText: String
//	public let type: Client.AccountType
	public let isStripeEnabled: Bool
	public let isVerified: Bool?
	public let photo: AccountPhoto?
	public let color: RGBComponents
	public var hasStoreItems: Bool?
	private var customData: CustomFields?
	public var autoFollow: [Int]?
	public var isRestaurant: Bool
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		url = try values.decodeIfPresent(URL.self, forKey: .url)
		stageBlocURL = try values.decode(URL.self, forKey: .stageBlocURL)
		name = try values.decode(String.self, forKey: .name)
		descriptiveText = try values.decode(String.self, forKey: .descriptiveText)
//		type = try values.decode(Client.AccountType.self, forKey: .type)
		isStripeEnabled = try values.decode(Bool.self, forKey: .isStripeEnabled)
		isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
		photo = try values.decodeIfPresent(AccountPhoto.self, forKey: .photo)
		color = try values.decode(RGBComponents.self, forKey: .color)
		isRestaurant = false
		do {
			if let customData = try values.decodeIfPresent(CustomFields.self, forKey: .customData) {
				if let follow = customData.autoFollow {
					autoFollow = follow.split(separator: ",").map { Int(String($0).trimmingCharacters(in: .whitespaces)) ?? 0 }
				}
				if let restaurantMode = customData.restaurant {
					isRestaurant = restaurantMode
				}
			}
		} catch {
			customData = nil
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, url, stageBlocURL = "stagebloc_url", name, descriptiveText = "description",/* type,*/ isStripeEnabled = "stripe_enabled", isVerified = "verified", photo, color, hasStoreItems, customData = "custom_field_data"
	}
	
}

extension Client {
	public enum UserAccountType {
		case admin
		case following
	}
	
	public func getAuthenticatedUserAccounts(forType type: UserAccountType, useCache: Bool = true, completionHandler: @escaping ([Account]?, Error?) -> Void) {
		let params = [
			"admin"		: (type == .admin ? 1:0),
			"following"	: (type == .following ? 1:0)
		]
		get(withEndPoint: "accounts", params: params, useCache: useCache, completionHandler: completionHandler)
	}
	
	public func getAuthenticatedUserAccounts(withIdentifier accountID: Int, useCache: Bool = true, completionHandler: @escaping (Account?, Error?) -> Void) {
		get(withEndPoint: "account/\(accountID)", useCache: useCache, completionHandler: completionHandler)
	}
	
	public func getPayworksKeysForAccount(withIdentifier accountID: Int, completionHandler: @escaping (PayworksMerchant?, Error?) -> Void) {
		get(withEndPoint: "account/\(accountID)/store/setting/secure", completionHandler: completionHandler)
	}
	
//	public static func createAccount(
//		name: String,
//		description: String,
//		url: String,
//		type: AccountType,
//		color: AccountColor) -> Endpoint<Account> {
//		return Endpoint(
//			path: "account",
//			method: .post,
//			parameters: [
//				"name"          : name,
//				"description"   : description,
//				"stagebloc_url" : url,
//				"type"          : type.rawValue,
//				"color"         : color.rawValue
//			])
//	}
//
//	public static func updateAccount(
//		withIdentifier accountID: Int,
//		name: String?,
//		description: String?,
//		url: String?,
//		type: AccountType?,
//		color: AccountColor?) -> Endpoint<Account> {
//		precondition(
//			name != nil || description != nil || url != nil || type != nil || color != nil,
//			"You can only create an update account endpoint with something to update"
//		)
//
//		return Endpoint(
//			path: "account/\(accountID)",
//			method: .post,
//			parameters: [
//				"name"          : name as Any,
//				"description"   : description as Any,
//				"stagebloc_url" : url as Any,
//				"type"          : type?.rawValue as Any,
//				"color"         : color?.rawValue as Any
//				].filterEntriesWithNilValues()
//		)
//	}
//
//	public static func updateImageForAccount(
//		withIdentifier accountID: Int,
//		formData: FormDataPart) -> Endpoint<Account> {
//		return Endpoint(
//			path: "/account/\(accountID)",
//			method: .post,
//			formData: [formData])
//	}
//
//	public static func followAccount(withIdentifier accountID: Int) -> Endpoint<Account> {
//		return Endpoint(
//			path: "/account/\(accountID)/follow",
//			method: .post,
//			keyPath: "data.account")
//	}
//
//	public static func unfollowAccount(withIdentifier accountID: Int) -> Endpoint<Account> {
//		return Endpoint(
//			path: "/account/\(accountID)/follow",
//			method: .delete,
//			keyPath: "data.account")
//	}
}

public struct PayworksMerchant: Codable {
	public let id: String
	public let secret: String
	
	private enum CodingKeys: String, CodingKey {
		case id = "payworks_merchant_identifier", secret = "payworks_merchant_secret_key"
	}
}
