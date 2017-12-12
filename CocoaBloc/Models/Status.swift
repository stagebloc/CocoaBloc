//
//  Status.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Status: APIObject {
	
	public let id: Int
	public let account: Expandable<Account>
	public let shortURL: URL
	public let text: String
	public let category: String
	public let inModeration: Bool
	public let isFanContent: Bool
	public let publishDate: Date
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		shortURL = try values.decode(URL.self, forKey: .shortURL)
		account = try values.decode(Expandable<Account>.self, forKey: .account)
		user = try values.decode(Expandable<User>.self, forKey: .user)
		text = try values.decode(String.self, forKey: .text)
		publishDate = try values.decode(Date.self, forKey: .publishDate)
//		let formatter = DateFormatter()
//		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//		guard let publish = try formatter.date(from: values.decode(String.self, forKey: .publishDate)) else {
//			throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.publishDate], debugDescription: "Expecting string representation of Date"))
//		}
//		publishDate = publish
		category = try values.decode(String.self, forKey: .category)
		inModeration = try values.decode(Bool.self, forKey: .inModeration)
		isFanContent = try values.decode(Bool.self, forKey: .isFanContent)
		commentCount = try values.decode(Int.self, forKey: .commentCount)
		likeCount = try values.decode(Int.self, forKey: .likeCount)
	}
}
