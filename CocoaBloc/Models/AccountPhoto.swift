//
//  AccountPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct AccountPhoto: APIObject {
	
	public let id: Int
	public let account: Expandable<Account>
	public let title: String
	public let category: String?
	public let creationDate: Date
	public let modificationDate: Date
	public let shortURL: URL
	public let descriptiveText: String
	public let width: Int
	public let height: Int
	public let isSticky: Bool
	public let isExclusive: Bool
	public let isInModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let imageURLs: ImageURLSet
	public let user: Expandable<User>
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		account = try values.decode(Expandable<Account>.self, forKey: .account)
		title = try values.decode(String.self, forKey: .title)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		
//		let formatter = DateFormatter()
//		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//		guard let creation = try formatter.date(from: values.decode(String.self, forKey: .creationDate)) else {
//			throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.creationDate], debugDescription: "Expecting string representation of Date"))
//		}
//		creationDate = creation
//		guard let modification = try formatter.date(from: values.decode(String.self, forKey: .modificationDate)) else {
//			throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.modificationDate], debugDescription: "Expecting string representation of Date"))
//		}
//		modificationDate = modification
		creationDate = try values.decode(Date.self, forKey: .creationDate)
		modificationDate = try values.decode(Date.self, forKey: .modificationDate)
		shortURL = try values.decode(URL.self, forKey: .shortURL)
		descriptiveText = try values.decode(String.self, forKey: .descriptiveText)
		width = try values.decode(Int.self, forKey: .width)
		height = try values.decode(Int.self, forKey: .height)
		isSticky = try values.decode(Bool.self, forKey: .isSticky)
		isExclusive = try values.decode(Bool.self, forKey: .isExclusive)
		isInModeration = try values.decode(Bool.self, forKey: .isInModeration)
		isFanContent = try values.decode(Bool.self, forKey: .isFanContent)
		commentCount = try values.decode(Int.self, forKey: .commentCount)
		likeCount = try values.decode(Int.self, forKey: .likeCount)
		imageURLs = try values.decode(ImageURLSet.self, forKey: .imageURLs)
		user = try values.decode(Expandable<User>.self, forKey: .user)
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, account, creationDate = "created", title, modificationDate = "modified", category, shortURL = "short_url", descriptiveText = "description", width, height, isSticky = "sticky", isExclusive = "exclusive", isInModeration = "in_moderation", isFanContent = "is_fan_content", commentCount = "comment_count", likeCount = "like_count", imageURLs = "images", user
	}
}
