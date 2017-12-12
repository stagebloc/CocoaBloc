//
//  Comment.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Comment: APIObject {
	
	public let id: Int
	public let text: String
	public let user: Expandable<User>
	public let creationDate: Date
	public let account: Expandable<Account>
	public let replyToIdentifier: Int
	public let replyCount: Int
	public let shortURL: URL
	public let inModeration: Bool
	
}
