//
//  StoreItem.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Curry

public struct StoreItem: Decodable, Identifiable {
	
	// MARK: Types
	
	public struct Option: Decodable {
		let name: String
		let sku: String
		let disabled: Bool
		let upc: String
		let unlimited: Bool
		let soldOut: Bool
		let quantity: Int
		let lowStockThreshold: Int
		let weight: Float
		let weightUnit: String
		let height: Float
		let width: Float
		let length: Float
		
		public static func decode(json: JSON) -> Decoded<Option> {
			let a = curry(Option.init)
				<^> json <| "name"
				<*> json <| "sku"
				<*> json <| "disabled"
				<*> json <| "upc"
				<*> json <| "unlimited"
				<*> json <| "sold_out"
				<*> json <| "quantity"
			return a
				<*> json <| "low_stock_threshold"
				<*> json <| "weight"
				<*> json <| "weight_unit"
				<*> json <| "height"
				<*> json <| "width"
				<*> json <| "length"
		}
	}
	
	public enum Type: Decodable {
		case Digital(freeDownload: Bool, requireFollow: Bool)
		case Bundle(storeItems: [StoreItem] /*audio: [SBAudio], playlists */)
		case Physical(shippingPriceHandlers: [ShippingPriceHandler], fulfiller: ShippingFulfiller)
		
		public static func decode(json: JSON) -> Decoded<Type> {
			switch json {
			case .String(let string):
				
			}
		}
	}
	
	public enum Currency {
		case USD
	}
	
	public struct Sale {
		public let amountOff: Double
		public let startDate: NSDate
		public let endDate: NSDate
	}
	
	// MARK: Properties
	
	public let identifier: Int
	public let type: Type
	public let account: Expandable<Account>
	public let title: String
	public let shortURL: NSURL
	public let descriptiveText: String
	public let soldOut: Bool
	public let exclusive: Bool
	public let featured: Bool
	public let creationDate: NSDate
	public let creator: Expandable<User>
	public let modificationDate: NSDate
	public let modifier: Expandable<User>
	public let category: String
	public let sale: Sale?
	public let tags: [String]
	public let fansNamePrice: Bool
	public let options: [Option]
	public let prices: [Currency: Double]
	public let coverPhoto: Expandable<AccountPhoto>
	public let photos: [AccountPhoto]
	
	public static func decode(json: JSON) -> Decoded<StoreItem> {
		return curry(StoreItem.init)
			<^> json <| "identifier"
			<*> json <| "type"
		
	}
}
