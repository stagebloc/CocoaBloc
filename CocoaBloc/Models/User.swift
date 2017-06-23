//
//  User.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct User: Identifiable {
	
	public let identifier: Int
	public let url: URL?
	public let creationDate: Date
	public let name: String
	public let username: String
	public let bio: String?
	public let photo: UserPhoto?
//	public let birthday: Date?
	public let gender: String?
	public let emailAddress: String?
	public let color: RGBComponents
	
	public init(identifier: Int = 0, url: URL? = nil, creationDate: Date = Date(), name: String, username: String, bio: String?, photo: UserPhoto? = nil, gender: String? = nil, emailAddress: String?, color: RGBComponents = RGBComponents(red: 0, green: 0, blue: 0)) {
		self.identifier = identifier
		self.name = name
		self.username = username
		self.creationDate = creationDate
		self.bio = bio
		self.photo = photo
		self.gender = gender
		self.emailAddress = emailAddress
		self.url = url
		self.color = color
	}
}
