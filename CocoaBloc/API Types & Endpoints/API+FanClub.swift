//
//  API+FanClub.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation

extension API {
	
	public struct ContentStreamFilter: OptionSetType {
		public static let fan = ContentStreamFilter(rawValue: 1 << 0)
		public static let official = ContentStreamFilter(rawValue: 1 << 1)
		public static let includingAdminAccounts = ContentStreamFilter(rawValue: 1 << 2)
		public static let all: ContentStreamFilter = [fan, official, includingAdminAccounts]
	}
	
//	public static func getFanClubDashboard(accountID: Int) -> Endpoint<SBFanClubDashboard> {
//		return Endpoint(
//			path: "account\(accountID)/fanclub/dashboard",
//			method: .GET)
//	}
//	
//	public static func createFanClub(
//		accountID: Int,
//		title: String,
//		description: String,
//		tierInfo: [String:AnyObject]) -> Endpoint<SBFanClub> {
//		return Endpoint(
//			path: "account/\(accountID)/fanclub/",
//			method: .POST,
//			parameters: [
//				"title"         : title,
//				"description"   : description,
//				"tier_info"     : tierInfo
//			])
//	}
//	
//	public static func getFanClubs(accountID: Int, type: FanClubType) -> Endpoint<[SBFanClub]> {
//		return Endpoint(
//			path: "account/\(accountID)/fanclubs/\(type.rawValue)",
//			method: .GET)
//	}
//	
//	public static func getContentFromFollowedFanClubs(
//		filter: ContentStreamFilter = [.Fan, .IncludingAdminAccounts]) -> Endpoint<[SBContentStreamObject]> {
//		return Endpoint(
//			path: "account/fanclubs/following/content",
//			method: .GET,
//			parameters: [
//				"include_account_content": filter.contains(.Official),
//				"include_fan_content": filter.contains(.Fan),
//				"include_admin_accounts": filter.contains(.IncludingAdminAccounts),
//			])
//	}
	
	public static func getFanClub(accountID: Int) -> Endpoint<FanClub> {
		return Endpoint(
			path: "account/\(accountID)/fanclub",
			method: .GET)
	}
	
//	public static func getFanClubContent(accountID: Int) -> Endpoint<[SBContentStreamObject]> {
//		return Endpoint(
//			path: "account/\(accountID)/fanclub/content",
//			method: .GET)
//	}
}
