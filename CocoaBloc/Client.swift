//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo
import Alamofire

public final class Client {
	
	public let baseURL: NSURL
	private let manager: Manager
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	public var authenticationStateContainer: AuthenticationStateContainer
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationStateContainer: AuthenticationStateContainer
			= CallbackAuthenticationStateContainer(state: .unauthenticated, callback: nil),
		manager: Manager = .init(),
		baseURL: NSURL = NSURL(string: "https://api.stagebloc.com/v1")!) {
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
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = []) -> Request {
		var params: [String: AnyObject] = [
			"expand": (expansions + endpoint.expansions)
						.map { $0.rawValue }
						.joinWithSeparator(",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID
		}
		
		let request = manager.request(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			parameters: params,
			encoding: .URL,
			headers: authenticationStateContainer.state.token.map { token in
				return ["Authorization": "Token token=\"\(token)\""]
			}
		)
		
		if Serialized.self == AuthenticationState.self {
			request.response(
				responseSerializer: Request.cocoaBlocModelSerializer(AuthenticationState.self, keyPath: endpoint.keyPath),
				completionHandler: { [weak self] (response: Response<AuthenticationState, API.Error>) in
					self?.authenticationStateContainer.state = response.result.value ?? .unauthenticated
				})
		}
		
		return request
	}
	
	public func request<Serialized: Decodable where Serialized.DecodedType == Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: (Response<Serialized, API.Error>) -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func request<Serialized: Decodable where Serialized.DecodedType == Serialized>(
		endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		completion: (Response<[Serialized], API.Error>) -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func upload<Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: (Result<Request, API.Error>) -> ()) {
		guard let formData = endpoint.formData else { fatalError("Error: endpoint must contain FormData") }
		var params: [String: AnyObject] = [
			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joinWithSeparator(",")
		].withEntries(endpoint.parameters)
		
		if !authenticationStateContainer.state.isAuthenticated {
			params["client_id"] = clientID
		}
		
		manager.upload(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
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
					guard let value = String(value).dataUsingEncoding(NSUTF8StringEncoding) else {
						fatalError("Invalid parameter type")
					}
					multipartData.appendBodyPart(data: value, name: key)
				}
			},
			encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold) { encodingResult in
				switch encodingResult {
				case .Success(let request, _, _):
					completion(.Success(request))
				case .Failure:
					completion(.Failure(.multipartDataEncoding))
				}
		}
	}

	public func uploadModelSerialization<Serialized: Decodable where Serialized.DecodedType == Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Request) -> ())? = nil,
		completion: (Result<Serialized, API.Error>) -> ()) {
		upload(endpoint, expansions: expansions) { (result: Result<Request, API.Error>) in
			switch result {
			case .Success(let request):
				requestConfiguration?(request)
				request.response(
					responseSerializer: Request.cocoaBlocModelSerializer(Serialized.self, keyPath: endpoint.keyPath),
					completionHandler: { response in
						completion(response.result)
					})
			case .Failure(let error):
				completion(.Failure(error))
			}
		}
	}

	public func uploadArraySerialization<Serialized: Decodable where Serialized.DecodedType == Serialized>(
		endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Request) -> ())? = nil,
		completion: (Result<[Serialized], API.Error>) -> ()) {
		upload(endpoint, expansions: expansions) { (result: Result<Request, API.Error>) in
			switch result {
			case .Success(let request):
				requestConfiguration?(request)
				request.response(
					responseSerializer: Request.cocoaBlocModelSerializer(
						Serialized.self,
						keyPath: endpoint.keyPath),
					completionHandler: { response in
						completion(response.result)
					}
				)
			case .Failure(let error):
				completion(.Failure(error))
			}
		}
	}
	
}
