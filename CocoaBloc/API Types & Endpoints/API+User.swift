//
//  API+User.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo
import Foundation
import Alamofire

extension API {

	public static func loginWithAuthorizationCode<AuthState: AuthenticationStateType>(
		authorizationCode: String) -> Endpoint<AuthState> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			parameters: [
				"code": authorizationCode,
				"grant_type": "authorization_code"
			],
			keyPath: "data")
	}
	
	public static func logInWithUsername<AuthState: AuthenticationStateType>(
		username: String,
		password: String) -> Endpoint<AuthState> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			expansions: [.user],
			parameters: [
				"username": username,
				"password": password,
				"grant_type": "password"
			],
			keyPath: "data")
	}
	
	public static func getUser(userID: Int) -> Endpoint<User> {
		return Endpoint(
			path: "users/\(userID)",
			method: .GET)
	}
	
	public static func getCurrentlyAuthenticatedUser() -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .GET)
	}
	
	public static func banUser(userID: Int, accountID: Int, reason: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/\(userID)/ban/\(accountID)",
			method: .POST)
	}
	
	public static func sendPasswordReset(email: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/password/reset",
			method: .POST,
			parameters: [
				"email" : email
			])
	}
	
	public static func updateUserLocation(latitude: Double, longitude: Double) -> Endpoint<User> {
		return Endpoint(
			path: "users/me/location/update",
			method: .POST,
			parameters: [
				"latitude" : latitude,
				"longitude" : longitude
			])
	}

	public static func updateAuthenticatedUser(
		bio: String?,
		birthday: NSDate?,
		email: String?,
		username: String?,
		name: String?,
		gender: Gender?,
		color: UserColor?) -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .POST,
			parameters: [
				"bio"       : bio,
				"birthday"  : birthday,
				"email"     : email,
				"name"      : name,
				"username"  : username,
				"gender"    : gender?.rawValue,
				"color"     : color?.rawValue
			].filterNil())
	}
	
	public static func updateAuthenticatedUserImage(formData: FormDataPart) -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .POST,
			formData: [formData])
	}
	
	public static func signUp(
		email: String,
		name: String,
		password: String,
		bio: String?,
		birthday: NSDate,
		gender: Gender,
		sourceAccountID: Int?) -> Endpoint<User> {
		let df = NSDateFormatter()
		df.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
		df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		df.dateFormat = "yyyy-MM-dd"
		
		return Endpoint(
			path: "users",
			method: .POST,
			parameters: [
				"email"     : email,
				"name"      : name,
				"bio"       : bio,
				"password"  : password,
				"birthday"  : df.stringFromDate(birthday),
				"gender"    : gender.rawValue,
				"source_account_id" : sourceAccountID
			].filterNil(),
			keyPath: "data.user")
	}
	
	public static func getFollowingUsersForAccount(accountID: Int) -> Endpoint<[User]> {
		return Endpoint(
			path: "account/\(accountID)/fans",
			method: .GET)
	}
	
//	public static func getContentForUser(
//		userID: Int,
//		contentListType: ContentListType
//	) -> Endpoint<[SBContentStreamObject]> {
//		return Endpoint(
//			path: "users/\(userID)/content/\(contentListType.rawValue)",
//			method: .GET)
//	}
}
