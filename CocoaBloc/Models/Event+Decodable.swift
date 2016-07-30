//
//  Event+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension Event: Decodable {
	
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
