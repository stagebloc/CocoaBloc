//
//  Client+Error.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-06.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

extension Client {
	public enum APIError: Error {
		case requestFailed
		case api(APIMetadata)
		case system(String)
		case underlying(Error)
		case jsonParsingFailure(String)
		case responseUnsuccessful
		
//		public var errorString: String {
//			switch self {
//			case .system(let error):
//				return error
//			case .underlying(let error):
//				return error.localizedDescription
//			case .api(let meta):
//				return meta.error ?? "API Error"
//			}
//		}
		
		public var localizedDescription: String {
			switch self {
			case .requestFailed: return "Request Failed"
			case .api(let metadata): return metadata.error ?? (metadata.dev_notes ?? "API Error")
			case .responseUnsuccessful: return "Response Unsuccessful"
			case .jsonParsingFailure(let desc): return "JSON Parsing Failure: \(desc)"
			case .underlying(let error): return error.localizedDescription
			case .system(let system): return system
			}
		}
	}
	
	public enum ErrorType: String, Codable {
		case invalidData			= "InvalidData"
		case notFound				= "NotFound"
		case databaseError			= "DatabaseError"
		case userNotAuthorized		= "UserNotAuthorized"
		case invalidRoute			= "InvalidRoute"
		case missingData			= "MissingData"
		case invalidLogin			= "InvalidLogin"
		case unauthorizedGrantType	= "UnauthorizedGrantType"
		case error					= "Error"
	}
	
	public struct ErrorInfo: Codable {
		public let type: ErrorType
		public let descriptiveText: String
		public let devNotes: String?
		
		private enum CodingKeys: String, CodingKey {
			case type = "error_type", descriptiveText = "error", devNotes = "dev_notes"
		}
	}
}
