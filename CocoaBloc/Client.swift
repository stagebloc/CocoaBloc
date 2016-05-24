//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Argo
import Alamofire

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
	
	public func request<Serialized>(
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
	
	public func request<Serialized: Decodable>(
		endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<Serialized.DecodedType, CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.DecodableResponseSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
	public func request<Serialized: Decodable where Serialized.DecodedType == Serialized>(
		endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		completion: Response<[Serialized.DecodedType], CocoaBloc.Error> -> ()) -> Request {
		let req = request(endpoint, expansions: expansions)
		return req.response(
			responseSerializer: Request.DecodableResponseSerializer(Serialized.self, keyPath: endpoint.keyPath),
			completionHandler: completion
		)
	}
	
//
//	public func upload<Serialized>(
//		endpoint: Endpoint<Serialized>,
//		expansions: [API.ExpandableValue] = [],
//		completion: Result<Request, Error> -> ()) {
//		guard let formData = endpoint.formData else { fatalError("Error: endpoint must contain FormData") }
//		var params: [String: AnyObject] = [
//			"expand": (["kind"] + (expansions + endpoint.expansions).map { $0.rawValue }).joinWithSeparator(",")
//			].withEntries(endpoint.parameters)
//		
//		if !authenticated {
//			params["client_id"] = clientID
//		}
//		
//		manager.upload(
//			endpoint.method,
//			baseURL.URLByAppendingPathComponent(endpoint.path),
//			headers: authenticated ?
//				["Authorization": "Token token=\"\(authenticationState.authenticationToken!)\""] : nil,
//			multipartFormData: { multipartData in
//				formData.forEach {
//					let title = $0.title
//					switch $0.dataType {
//					case .Data(let data):
//						multipartData.appendBodyPart(
//							data: data,
//							name: title,
//							fileName: title,
//							mimeType: data.photoMime())
//					case .File(let url):
//						multipartData.appendBodyPart(
//							fileURL: url,
//							name: title,
//							fileName: title,
//							mimeType: url.photoMime())
//					}
//				}
//				params.forEach { key, value in
//					guard let value = String(value).dataUsingEncoding(NSUTF8StringEncoding) else {
//						fatalError("Invalid parameter type")
//					}
//					multipartData.appendBodyPart(data: value, name: key)
//				}
//			},
//			encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold) { encodingResult in
//				switch encodingResult {
//				case .Success(let request, _, _):
//					completion(.Success(request))
//				case .Failure:
//					completion(.Failure(.MultipartDataEncoding))
//				}
//		}
//	}
//	
//	public func uploadModelSerialization<Serialized: Decodable>(
//		endpoint: Endpoint<Serialized>,
//		expansions: [API.ExpandableValue] = [],
//		requestConfiguration: (Alamofire.Request -> ())? = nil,
//		completion: Result<Serialized, CocoaBloc.Error> -> ()) {
//		upload(endpoint, expansions: expansions) { (result: Result<Request, Error>) in
//			switch result {
//			case .Success(let request):
//				requestConfiguration?(request)
//				request.response(
//					responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
//					completionHandler: { response in
//						completion(response.result)
//					})
//			case .Failure(let error):
//				completion(.Failure(error))
//			}
//		}
//	}
//
//	public func uploadArraySerialization<Serialized: SequenceType where Serialized.Generator.Element: Decodable>(
//		endpoint: Endpoint<Serialized>,
//		expansions: [API.ExpandableValue] = [],
//		requestConfiguration: (Alamofire.Request -> ())? = nil,
//		completion: Result<[Serialized.Generator.Element], CocoaBloc.Error> -> ()) {
//		upload(endpoint, expansions: expansions) { (result: Result<Request, Error>) in
//			switch result {
//			case .Success(let request):
//				requestConfiguration?(request)
//				request.response(
//					responseSerializer: Request.MantleResponseSerializer(endpoint.keyPath),
//					completionHandler: { response in
//						completion(response.result)
//				})
//			case .Failure(let error):
//				completion(.Failure(error))
//			}
//		}
//	}
	
	public func logoutAuthenticatedUser() {
		authenticationState.authenticationToken = nil
		authenticationState.authenticatedUser = nil
	}
}
