//
//  Status.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Status: Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let shortURL: NSURL
	public let text: String
	public let category: String
	public let inModeration: Bool
	public let isFanContent: Bool
	public let publishDate: NSDate
	public let commentCount: Int
	public let likeCount: Int
	public let user: Expandable<User>
	
}
