//
//  Blog.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Blog: Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let body: String
	public let strippedBody: String
	public let category: String
	public let slug: String
	public let shortURL: NSURL
	public let publishDate: NSDate
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let isSticky: Bool
	public let isExclusive: Bool
	public let inModeration: Bool
	public let isFanContent: Bool
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
}
