//
//  Client+Error.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-06.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

extension Client {
	public enum APIError: Error {
		case api(APIMetadata)
		case system(String)
		case underlying(Error)
		
		public var errorString: String {
			switch self {
			case .system(let error):
				return error
			case .underlying(let error):
				return error.localizedDescription
			case .api(let meta):
				return meta.error ?? "API Error"
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
