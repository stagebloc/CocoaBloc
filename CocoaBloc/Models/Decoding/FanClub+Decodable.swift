//
//  FanClub+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension FanClub: Decodable {
	
	public static func decode(json: JSON) -> Decoded<FanClub> {
		return curry(FanClub.init)
			<^> json <| "id"
			<*> json <| "title"
			<*> json <| "description"
			<*> json <| "account"
			<*> json <| "moderation_queue"
	}

}
