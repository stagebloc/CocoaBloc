//
//  User.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct User: APIObject {
	
	public let id: Int
	public let url: URL?
	public let created: Date?
	public let name: String
	public let username: String
	public let bio: String?
	public let phone: String?
	public let photo: UserPhoto?
	public let birthday: Date?
	public let gender: Client.Gender?
	public let emailAddress: String?
	public let color: RGBComponents
	
	public init(id: Int = 0, url: URL? = nil, created: Date? = nil, name: String, username: String, bio: String?, photo: UserPhoto? = nil, birthday: Date? = nil , gender: Client.Gender? = nil, emailAddress: String?, color: RGBComponents, phone: String = "") {
		self.id = id
		self.name = name
		self.username = username
		self.created = created
		self.bio = bio
		self.photo = photo
		self.gender = gender
		self.emailAddress = emailAddress
		self.url = url
		self.color = color
		self.birthday = birthday
		self.phone = phone
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		url = try values.decodeIfPresent(URL.self, forKey: .url)
		name = try values.decode(String.self, forKey: .name)
		username = try values.decode(String.self, forKey: .username)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		photo = try values.decodeIfPresent(UserPhoto.self, forKey: .photo)
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		if let creation = try values.decodeIfPresent(String.self, forKey: .created) {
			created = formatter.date(from: creation)
		} else { created = nil }
		emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
		gender = try values.decodeIfPresent(Client.Gender.self, forKey: .gender)
		color = try values.decode(RGBComponents.self, forKey: .color)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		
		formatter.dateFormat = "yyyy-MM-dd"
		if let bday = try values.decodeIfPresent(String.self, forKey: .birthday) {
			birthday = formatter.date(from: bday)
		} else { birthday = nil }
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, name, emailAddress = "email", phone = "phone_number", username, gender, photo, color, birthday, url, bio, created
	}
}

private struct LoginPost: Codable {
	public let username: String?
	public let password: String?
	public let code: String?
	public let grant_type: String?
	public let expand: String?
}

private struct SignUpPost: Codable {
	public let email: String?
	public let name: String?
	public let bio: String?
	public let password: String?
	public let birthday: String?
	public let gender: String?
	public let source_account_id: Int?
}

extension Client {
	
	public func logIn(authorizationCode: String, completionHandler: @escaping (Result<AuthenticationState, APIError>) -> Void) {
		let postCancel = LoginPost(username: nil, password: nil, code: authorizationCode, grant_type: "authorization_code", expand: "user")
		do {
			let encoder = JSONEncoder()
			let postCancelJSON = try encoder.encode(postCancel)
			post(withEndPoint: "oauth2/token", postJSON: postCancelJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(.failure(.system("Failed to encode request to JSON")))
		}
	}
	
	public func logIn(usernameOrEmail: String, password: String, useCache: Bool = true, completionHandler: @escaping (Result<AuthenticationState, APIError>) -> Void) {
		let params = [
			"username"	: usernameOrEmail,
			"password"	: password,
			]
		let postCancel = LoginPost(username: usernameOrEmail, password: password, code: nil, grant_type: "password", expand: "user")
		do {
			let encoder = JSONEncoder()
			let postCancelJSON = try encoder.encode(postCancel)
			post(withEndPoint: "oauth2/token", postJSON: postCancelJSON, params: params, useCache: useCache) { [unowned self] (result: Result<AuthenticationState, APIError>) in
				switch result {
				case .success(let state):
					if state.user != nil {
						self.authenticationState = state
					}
					completionHandler(.success(state))
				case .failure(let error):
					completionHandler(.failure(error))
				}
			}
		} catch {
			completionHandler(.failure(.system("Failed to encode request to JSON")))
		}
	}
	
//		public func logIn(usernameOrEmail: String, password: String, useCache: Bool = true, completionHandler: @escaping (AuthenticationState?, Error?) -> Void) {
//
//			let params = [
//				"username"	: usernameOrEmail,
//				"password"	: password,
//				"grant_type": "password",
//				"expand"	: ["user"]
//				] as [String : Any]
//			//		get(withEndPoint: "accounts", params: params, useCache: useCache, completionHandler: completionHandler)
//			//
//			//		let postCancel = LoginPost(username: usernameOrEmail, password: password, code: nil, grant_type: "password", expand: "user")
//			//		do {
//			//			let encoder = JSONEncoder()
//			//			let postCancelJSON = try encoder.encode(postCancel)
//			post(withEndPoint: "oauth2/token", params: params, useCache: useCache) { [unowned self] (state: AuthenticationState?, error: Error?) in
//				guard error == nil else {
//					completionHandler(nil, error)
//					return
//				}
//				if let state = state, let _ = state.user {
//					self.authenticationState = state
//				}
//				completionHandler(state, error)
//			}
//			//		} catch {
//			//			completionHandler(nil, error)
//			//		}
//		}

	
	public func getUser(withIdentifier userID: Int, completionHandler: @escaping (Result<User, APIError>) -> Void) {
		get(withEndPoint: "users/\(userID)", completionHandler: completionHandler)
	}
	
	public func getCurrentlyAuthenticatedUser(completionHandler: @escaping (Result<User, APIError>) -> Void) {
		get(withEndPoint: "users/me", completionHandler: completionHandler)
	}
	
	public func banUser(withIdentifier userID: Int, accountID: Int, reason: String, completionHandler: @escaping (Result<String, APIError>) -> Void) {
		post(withEndPoint: "users/\(userID)/ban/\(accountID)", completionHandler: completionHandler)
	}
	
	public func sendPasswordReset(to email: String, completionHandler: @escaping (Result<String, APIError>) -> Void) {
		let params = [
			"email" : email
		]
		post(withEndPoint: "users/password/reset", params: params, completionHandler: completionHandler)
	}
	
	public func updateUserLocation(latitude: Double, longitude: Double, completionHandler: @escaping (Result<User, APIError>) -> Void) {
		let params = [
			"latitude" : latitude,
			"longitude" : longitude
		]
		post(withEndPoint: "users/me/location/update", params: params, completionHandler: completionHandler)
	}
	
	public func updateAuthenticatedUser(bio: String?, birthday: Date?, email: String?, username: String?, name: String?, gender: Gender?, completionHandler: @escaping (Result<User, APIError>) -> Void) {
		let df = DateFormatter()
		df.locale = Locale(identifier: "EN_US_POSIX")
		df.timeZone = TimeZone(secondsFromGMT: 0)
		df.dateFormat = "yyyy-MM-dd"
		
		let signUpPost: SignUpPost = SignUpPost(email: email, name: name, bio: bio, password: nil, birthday: birthday != nil ? df.string(from: birthday!) : nil, gender: gender?.rawValue, source_account_id: nil)
		do {
			let encoder = JSONEncoder()
			let signUpPostJSON = try encoder.encode(signUpPost)
			post(withEndPoint: "users/me", postJSON: signUpPostJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(.failure(.system("Failed to encode request to JSON")))
		}
	}
	
	public func updateAuthenticatedUser(
		user: User, completionHandler: @escaping (Result<User, APIError>) -> Void) {
		updateAuthenticatedUser(bio: user.bio, birthday: nil, // user.birthday
			email: user.emailAddress,
			username: user.username,
			name: user.name,
			gender: user.gender ?? Client.Gender.other, completionHandler: completionHandler)
	}
	
//	public static func updateAuthenticatedUserImage(_ formData: FormDataPart) -> Endpoint<User> {
//		return Endpoint(
//			path: "users/me",
//			method: .post,
//			formData: [formData])
//	}
	
	public func signUp(email: String, name: String, password: String, bio: String?, birthday: Date, gender: Gender, sourceAccountID: Int, completionHandler: @escaping (Result<AuthenticationState, APIError>) -> Void) {
		let df = DateFormatter()
		df.locale = Locale(identifier: "EN_US_POSIX")
		df.timeZone = TimeZone(secondsFromGMT: 0)
		df.dateFormat = "yyyy-MM-dd"
		
		let signUpPost: SignUpPost = SignUpPost(email: email, name: name, bio: bio, password: password, birthday: df.string(from: birthday), gender: gender.rawValue, source_account_id: sourceAccountID)
		do {
			let encoder = JSONEncoder()
			let signUpPostJSON = try encoder.encode(signUpPost)
			post(withEndPoint: "users", postJSON: signUpPostJSON) { [unowned self] (result: Result<AuthenticationState, APIError>) in
				switch result {
				case .success(let state):
					if state.user != nil {
						self.authenticationState = state
					}
					completionHandler(.success(state))
				case .failure(let error):
					completionHandler(.failure(error))
				}
			}
		} catch {
			completionHandler(.failure(.system("Failed to encode request to JSON")))
		}
	}
	
	public func getUsersFollowingAccount(withIdentifier accountID: Int, completionHandler: @escaping (Result<[User], APIError>) -> Void) {
		get(withEndPoint: "", completionHandler: completionHandler)
	}
}
