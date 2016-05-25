//
//  FanClub.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct FanClub: Decodable, Identifiable {
	
	public let identifier: Int
	public let title: String
	public let descriptiveText: String
	public let account: Expandable<Account>
	public let moderationQueue: Bool
	
	public static func decode(json: JSON) -> Decoded<FanClub> {
		return curry(FanClub.init)
			<^> json <| "id"
			<*> json <| "title"
			<*> json <| "description"
			<*> json <| "account"
			<*> json <| "moderation_queue"
	}
}