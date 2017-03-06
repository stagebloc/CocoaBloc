//
//  FanClub+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry
import Runes

extension FanClub: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<FanClub> {
		return curry(FanClub.init)
			<^> json <| "title"
			<*> json <| "description"
			<*> json <| "account"
			<*> json <| "moderation_queue"
			<*> decodedJSON(json, forKey: "tier_info").flatMap { itemsJson in
				switch itemsJson {
				case .object(let jsonItemsMap):
					return sequence(jsonItemsMap.values.map(Tier.decode))
				default:
					return pure([])
				}
		}
	}
}

extension FanClub.Tier: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<FanClub.Tier> {
		let a = curry(FanClub.Tier.init)
			<^> json <| "title"
			<*> json <| "description"
			<*> json <| "price"
			<*> json <| "discount"
		return a
			<*> json <| "membership_length_interval"
			<*> json <| "membership_length_unit"
			<*> json <|? "renewal_price"
	 }
}

extension FanClub.Tier.TimeUnit: Decodable { }
