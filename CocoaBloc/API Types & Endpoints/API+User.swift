//
//  API+User.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

extension API {

	public static func logIn(
		authorizationCode authorizationCode: String) -> Endpoint<AuthenticationState> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			parameters: [
				"code": authorizationCode,
				"grant_type": "authorization_code"
			])
	}
	
	public static func logIn(
		usernameOrEmail usernameOrEmail: String,
		password: String) -> Endpoint<AuthenticationState> {
		return Endpoint(
			path: "oauth2/token",
			method: .POST,
			expansions: [.user],
			parameters: [
				"username": usernameOrEmail,
				"password": password,
				"grant_type": "password"
			])
	}
	
	public static func getUser(withIdentifier userID: Int) -> Endpoint<User> {
		return Endpoint(
			path: "users/\(userID)",
			method: .GET)
	}
	
	public static func getCurrentlyAuthenticatedUser() -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .GET)
	}
	
	public static func banUser(
		withIdentifier userID: Int,
		               accountID: Int,
		               reason: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/\(userID)/ban/\(accountID)",
			method: .POST)
	}
	
	public static func sendPasswordReset(to email: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/password/reset",
			method: .POST,
			parameters: [
				"email" : email
			])
	}
	
	public static func updateUserLocation(latitude latitude: Double, longitude: Double) -> Endpoint<User> {
		return Endpoint(
			path: "users/me/location/update",
			method: .POST,
			parameters: [
				"latitude" : latitude,
				"longitude" : longitude
			])
	}

	public static func updateAuthenticatedUser(
		bio bio: String?,
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
			].filterEntriesWithNilValues())
	}
	
	public static func updateAuthenticatedUserImage(formData: FormDataPart) -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .POST,
			formData: [formData])
	}
	
	public static func signUp(
		email email: String,
		name: String,
		password: String,
		bio: String?,
		birthday: NSDate,
		gender: Gender,
		sourceAccountID: Int?) -> Endpoint<AuthenticationState> {
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
			].filterEntriesWithNilValues(),
			keyPath: "data")
	}
	
	public static func getUsersFollowingAccount(withIdentifier accountID: Int) -> Endpoint<[User]> {
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
