//
//  API+User.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

extension API {

	public static func logIn(
		authorizationCode: String) -> Endpoint<AuthenticationState> {
		return Endpoint(
			path: "oauth2/token",
			method: .post,
			parameters: [
				"code": authorizationCode,
				"grant_type": "authorization_code"
			])
	}
	
	public static func logIn(
		usernameOrEmail: String,
		password: String) -> Endpoint<AuthenticationState> {
		return Endpoint(
			path: "oauth2/token",
			method: .post,
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
			method: .get)
	}
	
	public static func getCurrentlyAuthenticatedUser() -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .get)
	}
	
	public static func banUser(
		withIdentifier userID: Int,
		               accountID: Int,
		               reason: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/\(userID)/ban/\(accountID)",
			method: .post)
	}
	
	public static func sendPasswordReset(to email: String) -> Endpoint<()> {
		return Endpoint(
			path: "users/password/reset",
			method: .post,
			parameters: [
				"email" : email
			])
	}
	
	public static func updateUserLocation(latitude: Double, longitude: Double) -> Endpoint<User> {
		return Endpoint(
			path: "users/me/location/update",
			method: .post,
			parameters: [
				"latitude" : latitude,
				"longitude" : longitude
			])
	}

	public static func updateAuthenticatedUser(
		bio: String?,
		birthday: Foundation.Date?,
		email: String?,
		username: String?,
		name: String?,
		gender: Gender?,
		color: UserColor?) -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .post,
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
	
	public static func updateAuthenticatedUserImage(_ formData: FormDataPart) -> Endpoint<User> {
		return Endpoint(
			path: "users/me",
			method: .post,
			formData: [formData])
	}
	
	public static func signUp(
		email: String,
		name: String,
		password: String,
		bio: String?,
		birthday: Foundation.Date,
		gender: Gender,
		sourceAccountID: Int?) -> Endpoint<AuthenticationState> {
		let df = DateFormatter()
		df.locale = Locale(identifier: "EN_US_POSIX")
		df.timeZone = TimeZone(secondsFromGMT: 0)
		df.dateFormat = "yyyy-MM-dd"
		
		return Endpoint(
			path: "users",
			method: .post,
			parameters: [
				"email"     : email,
				"name"      : name,
				"bio"       : bio,
				"password"  : password,
				"birthday"  : df.string(from: birthday),
				"gender"    : gender.rawValue,
				"source_account_id" : sourceAccountID
			].filterEntriesWithNilValues(),
			keyPath: "data")
	}
	
	public static func getUsersFollowingAccount(withIdentifier accountID: Int) -> Endpoint<[User]> {
		return Endpoint(
			path: "account/\(accountID)/fans",
			method: .get)
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
