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
		public let name: String
		public let sku: String
		public let isDisabled: Bool
		public let upc: String?
		public let isUnlimited: Bool
		public let isSoldOut: Bool
		public let quantity: Int?
		public let lowStockThreshold: Int
		public let weight: Float
		public let weightUnit: String
		public let height: Float
		public let width: Float
		public let length: Float
		public let additionalPrice: Double
		
		public static func decode(json: JSON) -> Decoded<Option> {
			let price: Decoded<Double> = decodedJSON(json, forKey: "additional_price").flatMap { priceJSON in
				switch priceJSON {
				case .Array(let priceEntriesJSON):
					return priceEntriesJSON.first! <| "price"
				default:
					return .missingKey("price")
				}
			}

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
				<*> price
		}
	}
	
	public enum Type: Decodable {
		case Digital(isFreeDownload: Bool, requiresFollow: Bool)
		case Physical(shippingPriceHandlers: [ShippingPriceHandler], fulfiller: ShippingFulfiller?)
		case Bundle(isLivingBundle: Bool, storeItems: [StoreItem])//, audio: [Audio]/*, playlists */)
		case Experience
		case GiftCard
		
		private enum TypeString: String {
			case Digital = "digital"
			case Physical = "physical"
			case Bundle = "bundle"
			case Experience = "experience"
			case GiftCard = "gift card"
		}
		
		public var APITypeString: String {
			switch self {
			case .Digital:
				return TypeString.Digital.rawValue
			case .Physical:
				return TypeString.Physical.rawValue
			case .Bundle:
				return TypeString.Bundle.rawValue
			case .Experience:
				return TypeString.Experience.rawValue
			case .GiftCard:
				return TypeString.GiftCard.rawValue
			}
		}
		
		public static func decode(json: JSON) -> Decoded<Type> {
			let typeString: Decoded<String> = json <| "type"
			
			return typeString.flatMap { typeStr in
				switch typeStr {
				case TypeString.Digital.rawValue:
					return curry(Type.Digital)
						<^> json <| ["free_download", "enabled"]
						<*> json <| ["free_download", "require_follow"] <|> pure(false)
					
				case TypeString.Physical.rawValue:
					return curry(Type.Physical)
						<^> json <|| "shipping_price_handlers"
						<*> json <|? "fulfiller"
					
				case TypeString.Bundle.rawValue:
					return curry(Type.Bundle)
						<^> json <| "living_bundle"
						<*> json <|| ["bundled_items", "store_items"] <|> pure([])
					
				case TypeString.Experience.rawValue:
					return pure(.Experience)
					
				case TypeString.GiftCard.rawValue:
					return pure(.GiftCard)
					
				default:
					return .customError("Unexpected store item type: \(typeStr)")
				}
			}
		}
	}
	
	public enum Currency: String, Decodable {
		case USD = "usd"
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
	public let type: Type
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
			<*> Type.decode(json)
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
