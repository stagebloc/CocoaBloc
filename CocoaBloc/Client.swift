//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public final class AuthenticationState: AuthenticationStateType {
	public var authenticationToken: String?
	public var authenticatedUser: SBUser?
	
	public init(authenticationToken: String? = nil, authenticatedUser: SBUser? = nil) {
		self.authenticationToken = authenticationToken
		self.authenticatedUser = authenticatedUser
	}
	
	public convenience init() {
		self.init(authenticationToken: nil, authenticatedUser: nil)
	}
}

public typealias Client = APIClient<AuthenticationState>

public final class APIClient<AuthStateType: AuthenticationStateType> {
	
	private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
	private let manager: Manager
	
	// OAuth2 application details
	public let clientID: String
	public let clientSecret: String
	
	public let authenticationState: AuthStateType
	
	public init(
		clientID: String,
		clientSecret: String,
		authenticationState: AuthStateType = .init(),
		manager: Manager = .init()) {
		self.clientID = clientID
		self.manager = manager
		self.clientSecret = clientSecret
		self.authenticationState = authenticationState
	}
	
	public var authenticated: Bool {
		return authenticationState.authenticationToken != nil
	}
	
	internal func request<Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = []) -> Request {
		var params: [String: AnyObject] = [
			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joinWithSeparator(",")
		].withEntries(endpoint.parameters)
		
		if !authenticated {
			params["client_id"] = clientID
		}
		
		let request = manager.request(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			parameters: params,
			encoding: .URL,
			headers: authenticated
						? ["Authorization": "Token token=\"\(authenticationState.authenticationToken!)\""]
						: nil
		).validate()
		
		endpoint.sideEffect?(request, authenticationState)
		
		return request
	}
	
	public func request<Serialized: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<Serialized, CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func request<Serialized: SequenceType where Serialized.Generator.Element: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<[Serialized.Generator.Element], CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func upload<Serialized>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Result<Request, Error> -> ()) {
		
		guard let formData = endpoint.formData else {
			fatalError("FormData must be provided when calling this method")
		}
		
		var params: [String: AnyObject] = [
			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joinWithSeparator(",")
			].withEntries(endpoint.parameters)
		
		if !authenticated {
			params["client_id"] = clientID
		}
		
		manager.upload(
			endpoint.method,
			baseURL.URLByAppendingPathComponent(endpoint.path),
			headers: authenticated ?
				["Authorization": "Token token=\"\(authenticationState.authenticationToken!)\""] : nil,
			multipartFormData: { multipartData in
				formData.forEach {
					let title = $0.title
					switch $0.dataType {
					case .Data(let data):
						guard let mime = data.photoMime() else { return }
						multipartData.appendBodyPart(data: data, name: title, mimeType: mime)
						print("Mime: \(mime)")
					case .File(let url):
						guard let mime = url.photoMime() else { return }
						multipartData.appendBodyPart(fileURL: url, name: title, fileName: title, mimeType: mime)
					}
				}
				params.forEach { (key, value) in
					guard let value = value.dataUsingEncoding(NSUTF8StringEncoding) else { return }
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
	
	public func uploadModelSerialization<Serialized: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Result<Response<Serialized, Error>, Error> -> ()) {
		upload(endpoint, expansions: expansions) { (result: Result<Request, Error>) in
			switch result {
			case .Success(let request):
				print("Request: \(request)")
				request.response(
					responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
					completionHandler: { response in
						completion(.Success(response))
					})
			case .Failure(let error):
				completion(.Failure(error))
			}
		}
	}

	public func uploadArraySerialization<Serialized: SequenceType where Serialized.Generator.Element: MTLModel>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Result<Response<[Serialized.Generator.Element], Error>, Error> -> ()) {
		upload(endpoint, expansions: expansions) { (result: Result<Request, Error>) in
			switch result {
			case .Success(let request):
				request.response(
					responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
					completionHandler: { response in
						completion(.Success(response))
				})
			case .Failure(let error):
				completion(.Failure(error))
			}
		}
	}
	
	public func logoutAuthenticatedUser() {
		authenticationState.authenticationToken = nil
		authenticationState.authenticatedUser = nil
	}
}
