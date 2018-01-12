//
//  Client.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-05.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

import Foundation

public enum Result<T, APIError>  {
	case success(T)
	case failure(APIError)
}

public final class Client: NSObject {
	
	public let baseURL: URL
	public let session: URLSession
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	@objc dynamic public var userID: Int = -1
	public var authenticationState: AuthenticationState {
		didSet {
			userID = authenticationState.user?.id ?? -1
		}
	}
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationState: AuthenticationState = .unauthenticated,
		session: URLSession,
		baseURL: URL = URL(string: "https://api.stagebloc.com/v1/")!) {
		self.clientID = clientID
		self.session = session
		self.clientSecret = clientSecret
		self.authenticationState = authenticationState
		self.baseURL = baseURL
		super.init()
	}

	public init(fromAdminClient client: Client) {
		self.clientID = client.clientID
		self.clientSecret = client.clientSecret
		self.authenticationState = .unauthenticated
		self.session = client.session
		self.baseURL = client.baseURL
		super.init()
	}
	
	public func deauthenticate() {
		authenticationState = .unauthenticated
	}
	
	public func urlForEndpoint(_ endpoint: String, params: [String:Any] = [:]) -> URL? {
		let paramsString = params.stringFromHttpParameters()
		return URL(string: "\(baseURL.absoluteString)\(endpoint)?\(paramsString)")
	}
	
	public enum ExpandableValue: String, Codable {
		case photo      = "photo"
		case photos     = "photos"
		case account    = "account"
		case user       = "user"
		case tags       = "tags"
		case audio      = "audio"
		case createdBy  = "created_by"
		case modifiedBy = "modified_by"
		case content    = "content"
	}
	
	public enum UserColor: String {
		case blue   = "blue"
		case teal   = "teal"
		case green  = "green"
		case pink   = "pink"
		case red    = "red"
		case purple = "purple"
	}
	
	public enum Gender: String, Codable {
		case male		= "male"
		case female		= "female"
		case cupcake	= "cupcake"
	}
	
	public enum ContentTypeIdentifier: String, Codable {
		case photo  = "photo"
		case audio  = "audio"
		case video  = "video"
		case blog   = "blog"
		case status = "status"
		case event	= "event"
		case store	= "store"
	}
	
	public enum ContentListType: String, Codable {
		case update	= "updates"
		case like	= "likes"
	}
	
	public enum AccountColor: String, Codable {
		case blue       = "blue"
		case purple     = "purple"
		case red        = "red"
		case orange     = "orange"
		case grey       = "grey"
		case green      = "green"
	}
	
	public enum AccountType: String, Codable {
		case music				= "music"
		case filmAndTV			= "film/tv"
		case entertainment		= "entertainment"
		case sports				= "sports"
		case celebrity			= "celebrity"
		case comedian			= "comedian"
		case recordLabel		= "record label"
		case managementCompany	= "management company"
		case personal			= "personal"
		case developer			= "developer"
		case photography		= "photography"
		case cooking			= "food"
		case business			= "business"
		case organization		= "organization"
		case other				= "other"
	}
	
	public enum FanClubType: String, Codable {
		case featured   = "featured"
		case recent     = "recent"
		case following  = "following"
	}
	
	public enum FlagType: String, Codable {
		case duplicate = "duplicate"
		case copyright = "copyright"
		case prejudice = "prejudice"
		case offensive = "offensive"
	}
	
	public struct Content: ContentType, Codable {
		public let contentType: ContentTypeIdentifier
		public let contentID: Int
		public let postedAccountID: Int
	}
	
	public struct APIMetadata: Codable {
		public let http_code: Int?
		public let code: Int?
		public let error_type: ErrorType?
		public let error: String?
		public let dev_notes: String?
	}
	
	public struct Response<Item>: Codable where Item: Codable {
		public let data: Item?
		public let metadata: APIMetadata
	}
	
	public func get<Item: Codable>(withEndPoint endPoint: String, params: [String: Any] = [:], useCache: Bool = false, completionHandler: @escaping (Result<Item, APIError>) -> Void) {
		var finalParams = params
		if !authenticationState.isAuthenticated {
			finalParams["client_id"] = clientID
		}
		finalParams["expand"] = finalParams["expand"] ?? ""
		guard let url = urlForEndpoint(endPoint, params: finalParams) else {
			print("Error: cannot create URL")
			let error = APIError.system("Error: cannot create URL")
			completionHandler(.failure(error))
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		urlRequest.cachePolicy = useCache ? .returnCacheDataElseLoad : .useProtocolCachePolicy
		
		request(with: urlRequest, completionHandler: completionHandler)
	}
	
	public func delete<Item: Codable>(withEndPoint endPoint: String, params: [String: Any] = [:], completionHandler: @escaping (Result<Item, APIError>) -> Void) {
		var finalParams = params
		if !authenticationState.isAuthenticated {
			finalParams["client_id"] = clientID
		}
		guard let url = urlForEndpoint(endPoint, params: finalParams) else {
			print("Error: cannot create URL")
			let error = APIError.system("Error: cannot create URL")
			completionHandler(.failure(error))
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "DELETE"
		
		request(with: urlRequest, completionHandler: completionHandler)
	}
	
	public func post<Item: Codable>(withEndPoint endPoint: String, postJSON: Data? = nil, params: [String: Any] = [:], useCache: Bool = false, completionHandler: @escaping (Result<Item, APIError>) -> Void) {
		var finalParams = params
		if !authenticationState.isAuthenticated {
			finalParams["client_id"] = clientID
		}
		guard let url = urlForEndpoint(endPoint, params: finalParams) else {
			print("Error: cannot create URL")
			let error = APIError.system("Error: cannot create URL")
			completionHandler(.failure(error))
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.cachePolicy = useCache ? .returnCacheDataElseLoad : .useProtocolCachePolicy
		
		if let postJSON = postJSON {
			urlRequest.httpBody = postJSON
			debugPrint("jsonData: ", String(data: urlRequest.httpBody!, encoding: .utf8) ?? "no body data")
		}
		
		request(with: urlRequest, completionHandler: completionHandler)
	}
	
	public func request<Item: Codable>(with request: URLRequest, completionHandler: @escaping (Result<Item, APIError>) -> Void) {
		var finalRequest = request
		if let token = authenticationState.token {
			finalRequest.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
		}
		finalRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		finalRequest.addValue(agentString(), forHTTPHeaderField: "User-Agent")
		print(debugRequestString(request: finalRequest))
		
		
		let task = session.dataTask(with: finalRequest, completionHandler: {
			(data, response, error) in
			guard error == nil else {
				completionHandler(.failure(APIError.underlying(error!)))
				return
			}
			// make sure we got data in the response
			guard let responseData = data else {
				print("Error: did not receive data")
				let error = APIError.system("No data in response")
				completionHandler(.failure(error))
				return
			}
//			debugPrint(String(data: responseData, encoding: .utf8) ?? "no data")
			
			// parse the result as JSON
			// then create an object from the JSON
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			formatter.isLenient = true
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(formatter)
			do {
				let response = try decoder.decode(Response<Item>.self, from: responseData)
				if let data = response.data {
					completionHandler(.success(data))
				} else {
					completionHandler(.failure(APIError.api(response.metadata)))
				}
			} catch {
				completionHandler(Result.failure(APIError.jsonParsingFailure(String(describing: Item.self))))
			}
		})
		task.resume()
	}
	
	private func agentString() -> String {
		if let name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, let ident = Bundle.main.infoDictionary![kCFBundleIdentifierKey as String] as? String, let build = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as? String {
			return "\(name)/\(version) (\(ident); build:\(build) \(UIDevice.current.systemVersion))"
		}
		return "Error"
	}
	
	private func debugRequestString(request: URLRequest) -> String {
		var string: String = "curl -v"
		string += " -X \(request.httpMethod ?? "")"
		for (key, value) in request.allHTTPHeaderFields ?? [:] {
			string += " -H \"\(key): \(value)\""
		}
		if let body = request.httpBody {
			string += " -d \'\(String(data: body, encoding: .utf8) ?? "no body")\'"
		}
		string += " \"\(request.url?.absoluteString ?? "")\""
		
		return string
	}
	
}

public protocol Identifiable {
	var id: Int { get }
}

public typealias APIObject = Codable & Identifiable

/// Protocol describing a type containing necessary information to reference
/// a piece of content through the Fullscreen Direct API.
public protocol ContentType {
	/// Which type of content the identifier belongs to
	var contentType: Client.ContentTypeIdentifier { get }
	/// The identifier of the content itself
	var contentID: Int { get }
	/// The identifier of the account on which this content is posted
	var postedAccountID: Int { get }
}
