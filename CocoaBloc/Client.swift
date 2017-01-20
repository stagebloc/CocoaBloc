//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo
import Alamofire

public typealias CallbackClient = Client<CallbackAuthenticationStateContainer>

public final class Client<AuthStateContainer: AuthenticationStateContainer> {
	
	public let baseURL: Foundation.URL
	fileprivate let manager: Alamofire.SessionManager
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	public var authenticationStateContainer: AuthStateContainer
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationStateContainer: AuthStateContainer = .init(),
		manager: SessionManager = .init(),
		baseURL: Foundation.URL = Foundation.URL(string: "https://api.stagebloc.com/v1")!) {
		self.clientID = clientID
		self.manager = manager
		self.clientSecret = clientSecret
		self.authenticationStateContainer = authenticationStateContainer
		self.baseURL = baseURL
	}
	
	public func deauthenticate() {
		authenticationStateContainer.state = .unauthenticated
	}
	
	public func request<Serialized>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = []) -> Alamofire.DataRequest {
		var params: [String: Any] = [
			"expand": (expansions + endpoint.expansions)
						.map { $0.rawValue }
						.joined(separator: ",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID as String?
		}

		let request = manager.request(
			baseURL.appendingPathComponent(endpoint.path),
			method: endpoint.method,
			parameters: params,
			encoding: JSONEncoding.default,
			headers: authenticationStateContainer.state.token.map { token in
							return ["Authorization": "Token token=\"\(token)\""]
			}
		)

		if Serialized.self == AuthenticationState.self {
			request.cocoaBlocModelSerializer(keyPath: endpoint.keyPath) { [weak self] (response: DataResponse<AuthenticationState>) in
			self?.authenticationStateContainer.state = response.result.value ?? .unauthenticated
			}
		}
		
		return request
	}
	
	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: @escaping (DataResponse<Serialized>) -> Void) -> Alamofire.DataRequest where Serialized.DecodedType == Serialized {
		let req = self.request(endpoint, expansions: expansions)
		debugPrint(req)
		
		return req.cocoaBlocModelSerializer(keyPath: endpoint.keyPath, completionHandler: completion)
	}

	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		completion: @escaping (DataResponse<[Serialized]>) -> Void) -> Alamofire.DataRequest where Serialized.DecodedType == Serialized {
		let req = request(endpoint, expansions: expansions)
		debugPrint(req)
		
		return req.cocoaBlocModelSerializer(
			keyPath: endpoint.keyPath,
			completionHandler: completion
		)
	}

	public func upload<Serialized>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: @escaping (Result<DataRequest>) -> Void) {
		guard let formData = endpoint.formData else { fatalError("Error: endpoint must contain FormData") }
		var params: [String: Any] = [
			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joined(separator: ",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID as String?
		}
		
		manager.upload(multipartFormData: { multipartData in
			formData.forEach {
				let title = $0.title
				switch $0.source {
				case .data(let data):
					multipartData.append(
						data,
						withName: title,
						fileName: title,
						mimeType: data.photoMime())
				case .file(let url):
					multipartData.append(
						url,
						withName: title,
						fileName: title,
						mimeType: url.photoMime())
				}
			}
			params.forEach { key, value in
				guard let value = String(describing: value).data(using: String.Encoding.utf8) else {
					fatalError("Invalid parameter type")
				}
				multipartData.append(value, withName: key)
			}
		}, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: baseURL.appendingPathComponent(endpoint.path), method: endpoint.method, headers: authenticationStateContainer.state.token.map { token in
			return ["Authorization": "Token token=\"\(token)\""]
		}) { encodingResult in
			switch encodingResult {
			case .success(let request, _, _):
				completion(.success(request))
			case .failure:
				completion(.failure(API.APIError.multipartDataEncoding))
			}
		}
		
	}

	public func uploadModelSerialization<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((DataRequest) -> Void)? = nil,
		completion: @escaping (Result<Serialized>) -> Void) where Serialized.DecodedType == Serialized {
		upload(endpoint, expansions: expansions) { (result: Result<DataRequest>) in
			switch result {
			case .success(let request):
				requestConfiguration?(request)
				request.cocoaBlocModelSerializer(keyPath: endpoint.keyPath, completionHandler: { response in
					completion(response.result)
				})
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	public func uploadArraySerialization<Serialized: Decodable>(
		_ endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((DataRequest) -> Void)? = nil,
		completion: @escaping (Result<[Serialized]>) -> Void) where Serialized.DecodedType == Serialized {
		upload(endpoint, expansions: expansions) { (result: Result<DataRequest>) in
			switch result {
			case .success(let request):
				requestConfiguration?(request)
				request.cocoaBlocModelSerializer(keyPath: endpoint.keyPath, completionHandler: { response in
					completion(response.result)
				})
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
}
