//
//  Account+Argo.Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension Account: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Account> {
		return curry(Account.init)
			<^> json <| "id"
			<*> json <|? "url"
			<*> json <| "stagebloc_url"
			<*> json <| "name"
			<*> json <| "description"
			//			<*> json <| "type"
			<*> json <| "stripe_enabled"
			<*> json <| "verified"
			<*> json <|? "photo"
			<*> json <| "color"
			<*> json <|? "hasStoreItems"
	}
	
}
