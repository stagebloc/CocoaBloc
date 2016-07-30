//
//  AccountPhoto.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct AccountPhoto: Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let category: String?
	public let creationDate: NSDate
	public let modificationDate: NSDate
	public let shortURL: NSURL
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
	
}
