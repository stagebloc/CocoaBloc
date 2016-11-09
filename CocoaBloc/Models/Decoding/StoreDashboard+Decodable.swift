//
//  StoreDashboard+Decodable.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2016-11-04.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

extension StoreDashboard: Decodable {
	
	public static func decode(json: JSON) -> Decoded<StoreDashboard> {
		let totals: Decoded<Totals> = decodedJSON(json, forKey: "totals").flatMap(Totals.decode)
		
		let revenue: Decoded<Revenue> = decodedJSON(json, forKey: "revenue").flatMap(Revenue.decode)
		
		let averages: Decoded<Averages> = decodedJSON(json, forKey: "averages").flatMap(Averages.decode)
		
		return curry(StoreDashboard.init)
			<^> json <| "kind"
			<*> totals
			<*> revenue
			<*> averages
	}
	
}

extension StoreDashboard.Totals: Decodable {
	
	public static func decode(json: JSON) -> Decoded<StoreDashboard.Totals> {
		return curry(StoreDashboard.Totals.init)
			<^> json <| "revenue"
			<*> json <| "shipping_handling"
			<*> json <| "tax"
			<*> json <| "orders"
	}
}

extension StoreDashboard.Revenue: Decodable {
	
	public static func decode(json: JSON) -> Decoded<StoreDashboard.Revenue> {
		return curry(StoreDashboard.Revenue.init)
			<^> json <| "store"
			<*> json <| "fan_club"
	}
}

extension StoreDashboard.Averages: Decodable {
	
	public static func decode(json: JSON) -> Decoded<StoreDashboard.Averages> {
		return curry(StoreDashboard.Averages.init)
			<^> json <| "order_price"
			<*> json <| "fan_value"
	}
}
