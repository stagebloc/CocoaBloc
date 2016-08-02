//
//  Event.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Event: Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let descriptiveText: String
	public let shortURL: URL
	public let ticketPrice: Float
	public let ticketLink: URL
	public let startDate: Date
	public let endDate: Date
	public let timeZone: String
	public let commentCount: Int
	public let likeCount: Int
	public let attendingCount: Int
	public let location: Address?
	
}
