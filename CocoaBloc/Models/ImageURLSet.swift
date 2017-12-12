//
//  ImageURLSet.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/26/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct ImageURLSet: Codable {
	
	public let thumbnail: URL
	public let small: URL
	public let medium: URL
	public let large: URL
	public let original: URL
	
	private enum CodingKeys: String, CodingKey {
		case thumbnail = "thumbnail_url", small = "small_url", medium = "medium_url", large = "large_url", original = "original_url"
	}
}
