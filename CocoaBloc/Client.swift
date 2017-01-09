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
	fileprivate let manager: SessionManager
	
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
		expansions: [API.ExpandableValue] = []) -> Request {
		var params: [String: String] = [
			"expand": (expansions + endpoint.expansions)
						.map { $0.rawValue }
						.joined(separator: ",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID as String?
		}
		
		let request = manager.request(
			endpoint.method,
			baseURL.appendingPathComponent(endpoint.path)!,
			parameters: params,
			encoding: (endpoint.method == .post) ? .json:.url,
			headers: authenticationStateContainer.state.token.map { token in
				return ["Authorization": "Token token=\"\(token)\""]
			}
		)
		
		if Serialized.self == AuthenticationState.self {
			request.response(
				responseSerializer: Request.cocoaBlocModelSerializer(AuthenticationState.self, keyPath: endpoint.keyPath),
				completionHandler: { [weak self] (response: Response<AuthenticationState>) in
					self?.authenticationStateContainer.state = response.result.value ?? .unauthenticated
				})
		}
		
		return request
	}
	
	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: (Response<Serialized>) -> ()) -> Request where Serialized.DecodedType == Serialized {
		let req = request(endpoint, expansions: expansions)
		debugPrint(req)
		return req.response(
			responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		completion: (Response<[Serialized]>) -> ()) -> Request where Serialized.DecodedType == Serialized {
		let req = request(endpoint, expansions: expansions)
		debugPrint(req)
		return req.response(
			responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func upload<Serialized>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: (Result<Request>) -> ()) {
		guard let formData = endpoint.formData else { fatalError("Error: endpoint must contain FormData") }
		var params: [String: String] = [
			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joined(separator: ",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID as String?
		}
		
		manager.upload(
			endpoint.method,
			baseURL.appendingPathComponent(endpoint.path)!,
			headers: authenticationStateContainer.state.token.map { token in
				return ["Authorization": "Token token=\"\(token)\""]
			},
			multipartFormData: { multipartData in
				formData.forEach {
					let title = $0.title
					switch $0.source {
					case .data(let data):
						multipartData.appendBodyPart(
							data: data,
							name: title,
							fileName: title,
							mimeType: data.photoMime())
					case .file(let url):
						multipartData.appendBodyPart(
							fileURL: url,
							name: title,
							fileName: title,
							mimeType: url.photoMime())
					}
				}
				params.forEach { key, value in
					guard let value = String(value).data(using: String.Encoding.utf8) else {
						fatalError("Invalid parameter type")
					}
					multipartData.appendBodyPart(data: value, name: key)
				}
			},
			encodingMemoryThreshold: SessionManager.MultipartFormDataEncodingMemoryThreshold) { encodingResult in
				switch encodingResult {
				case .success(let request, _, _):
					completion(.success(request))
				case .failure:
					completion(.failure(.multipartDataEncoding))
				}
		}
	}

	public func uploadModelSerialization<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Request) -> ())? = nil,
		completion: (Result<Serialized>) -> ()) where Serialized.DecodedType == Serialized {
		upload(endpoint, expansions: expansions) { (result: Result<Request>) in
			switch result {
			case .success(let request):
				requestConfiguration?(request)
				request.response(
					responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
					completionHandler: { response in
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
		requestConfiguration: ((Request) -> ())? = nil,
		completion: (Result<[Serialized]>) -> ()) where Serialized.DecodedType == Serialized {
		upload(endpoint, expansions: expansions) { (result: Result<Request>) in
			switch result {
			case .success(let request):
				requestConfiguration?(request)
				request.response(
					responseSerializer: Request.cocoaBlocModelSerializer(
						Serialized.self,
						keyPath: endpoint.keyPath),
					completionHandler: { response in
						completion(response.result)
					}
				)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
}
