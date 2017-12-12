//
//  UserPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/27/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct UserPhoto: Codable {
	
	public let width: Int
	public let height: Int
	public let imageURLs: ImageURLSet
	
	private enum CodingKeys: String, CodingKey {
		case width, height, imageURLs = "images"
	}
}
