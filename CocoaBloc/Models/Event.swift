//
//  Event.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct Event: Decodable, Identifiable {
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let descriptiveText: String
	public let shortURL: NSURL
	public let ticketPrice: Float
	public let ticketLink: NSURL
	public let startDate: NSDate
	public let endDate: NSDate
	public let timeZone: String
	public let commentCount: Int
	public let likeCount: Int
	public let attendingCount: Int
	public let location: Address?
	
	public static func decode(json: JSON) -> Decoded<Event> {
		let a = curry(Event.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "description"
			<*> json <| "short_url"
			<*> json <| "ticket_price"
			<*> json <| "ticket_link"
		return a
			<*> json <| "start_date_time"
			<*> json <| "end_date_tiem"
			<*> json <| "timezone"
			<*> json <| "comment_count"
			<*> json <| "like_count"
			<*> json <| "attending_count"
			<*> json <|? "location"
	}
}
