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
		let isDisabled: Bool
		let upc: String?
		let isUnlimited: Bool
		let isSoldOut: Bool
		let quantity: Int?
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
				<*> json <|? "upc"
				<*> json <| "unlimited"
				<*> json <| "sold_out"
				<*> json <|? "quantity"
			return a
				<*> json <| "low_stock_threshold"
				<*> json <| "weight"
				<*> json <| "weight_unit"
				<*> json <| "height"
				<*> json <| "width"
				<*> json <| "length"
		}
	}
	
//	public enum Type: Decodable {
//		case Digital(freeDownload: Bool, requireFollow: Bool)
//		case Bundle(storeItems: [StoreItem], audio: [Audio]/*, playlists */)
//		case Physical(shippingPriceHandlers: [ShippingPriceHandler], fulfiller: ShippingFulfiller)
//		
//		public static func decode(json: JSON) -> Decoded<Type> {
////			switch json {
////				
////			}
//		}
//	}
	
	public enum Currency: String, Decodable {
		case USD = "USD"
	}
	
	public struct Sale: Decodable {
		public let amountOff: Double
		public let startDate: NSDate
		public let endDate: NSDate
		
		public static func decode(json: JSON) -> Decoded<Sale> {
			return curry(Sale.init)
				<^> json <| "sale_amount"
				<*> json <| "sale_start_date"
				<*> json <| "sale_end_date"
		}
	}
	
	// MARK: Properties
	
	public let identifier: Int
//	public let type: Type
	public let account: Expandable<Account>
	public let title: String
	public let shortURL: NSURL
	public let descriptiveText: String
	public let isSoldOut: Bool
	public let exclusive: Bool
	public let featured: Bool
	public let creationDate: NSDate
	public let creator: Expandable<User>
	public let modificationDate: NSDate
	public let modifier: Expandable<User>
	public let category: String?
//	public let sale: Sale?
	public let tags: [String]
	public let isFansNamePrice: Bool
	public let options: [Option]
	public let priceUSD: Double
	public let coverPhoto: Expandable<AccountPhoto>?
	public let photos: ExpandableArray<AccountPhoto>?
	
	public static func decode(json: JSON) -> Decoded<StoreItem> {
		let price: Decoded<Double> = decodedJSON(json, forKey: "prices").flatMap { priceJSON in
			switch priceJSON {
			case .Array(let priceEntriesJSON):
				return priceEntriesJSON.first! <| "price"
			default:
				return .missingKey("price")
			}
		}
		
		let a = curry(StoreItem.init)
			<^> json <| "id"
//			<*> json <| "type"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "short_url"
			<*> json <| "description"
			<*> json <| "sold_out"
			<*> json <| "exclusive"
			<*> json <| "featured"
		return a
			<*> json <| "created"
			<*> json <| "created_by"
			<*> json <| "modified"
			<*> json <| "modified_by"
			<*> json <|? "category"
//			<*> json <|? "sale"
			<*> json <|| "tags" <|> pure([])
			<*> json <| "fans_name_price"
			<*> json <|| "options" <|> pure([])
			<*> price
			<*> json <|? "photo"
			<*> json <|? "photos"
	}
}
