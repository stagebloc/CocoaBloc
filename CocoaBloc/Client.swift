//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Argo
import Alamofire

public typealias Client = APIClient<AuthenticationState>

public final class APIClient<AuthStateType: AuthenticationStateType where
	AuthStateType.DecodedType == AuthStateType> {
	
	public let baseURL: NSURL
	private let manager: Manager
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	public private(set) var authenticationState: AuthStateType
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationState: AuthStateType = .init(authenticationToken: nil, authenticatedUser: nil),
		manager: Manager = .init(),
		baseURL: NSURL = NSURL(string: "https://api.stagebloc.com/v1")!) {
		self.clientID = clientID
		self.manager = manager
		self.clientSecret = clientSecret
		self.authenticationState = authenticationState
		self.baseURL = baseURL
	}
	
	public func deauthenticate() {
		authenticationState.authenticatedUser = nil
		authenticationState.authenticationToken = nil
	}
	
	public func request<Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = []) -> Request {
		var params: [String: AnyObject] = [
			"expand": (expansions + endpoint.expansions)
						.map { $0.rawValue }
						.joinWithSeparator(",")
		].withEntries(endpoint.parameters)
		
		if !authenticationState.isAuthenticated {
			params["client_id"] = clientID
		}
		
		let request = manager.request(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			parameters: params,
			encoding: .URL,
			headers: authenticationState.isAuthenticated
						? ["Authorization": "Token token=\"\(authenticationState.authenticationToken!)\""]
						: nil
		)
		
		if Serialized.self == AuthStateType.self {
			request.response(
				responseSerializer: Request.cocoaBlocModelSerializer(AuthStateType.self, keyPath: endpoint.keyPath),
				completionHandler: { [weak self] (response: Response<AuthStateType, API.Error>) in
					self?.authenticationState.authenticationToken = response.result.value?.authenticationToken
					self?.authenticationState.authenticatedUser = response.result.value?.authenticatedUser
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
		
		if !authenticationState.isAuthenticated {
			params["client_id"] = clientID
		}
		
		manager.upload(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			headers: authenticationState.isAuthenticated ?
				["Authorization": "Token token=\"\(authenticationState.authenticationToken!)\""] : nil,
			multipartFormData: { multipartData in
				formData.forEach {
					let title = $0.title
					switch $0.dataType {
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
					completion(.Failure(.MultipartDataEncoding))
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

	public func uploadArraySerialization<Serialized: SequenceType where
		Serialized.Generator.Element: Decodable,
		Serialized.Generator.Element.DecodedType == Serialized.Generator.Element>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Request) -> ())? = nil,
		completion: (Result<[Serialized.Generator.Element], API.Error>) -> ()) {
		upload(endpoint, expansions: expansions) { (result: Result<Request, API.Error>) in
			switch result {
			case .Success(let request):
				requestConfiguration?(request)
				request.response(
					responseSerializer: Request.cocoaBlocModelSerializer(
						Serialized.Generator.Element.self,
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
