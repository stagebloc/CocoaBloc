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
		public let additionalPrice: Double?
		
		public static func decode(json: JSON) -> Decoded<Option> {
			let price: Decoded<Double?> = .optional(decodedJSON(json, forKey: "additional_price").flatMap { priceJSON in
				switch priceJSON {
				case .Array(let priceEntriesJSON):
					return priceEntriesJSON.first! <| "price"
				default:
					return .missingKey("price")
				}
			})
			
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
		case digital(isFreeDownload: Bool, requiresFollow: Bool)
		case physical(shippingPriceHandlers: [ShippingPriceHandler], fulfiller: ShippingFulfiller?)
		case bundle(isLivingBundle: Bool, storeItems: [StoreItem])//, audio: [Audio]/*, playlists */)
		case experience
		case giftCard
		
		private enum TypeString: String {
			case digital = "digital"
			case physical = "physical"
			case bundle = "bundle"
			case experience = "experience"
			case giftCard = "gift card"
		}
		
		public var APITypeString: String {
			switch self {
			case .digital:
				return TypeString.digital.rawValue
			case .physical:
				return TypeString.physical.rawValue
			case .bundle:
				return TypeString.bundle.rawValue
			case .experience:
				return TypeString.experience.rawValue
			case .giftCard:
				return TypeString.giftCard.rawValue
			}
		}
		
		public static func decode(json: JSON) -> Decoded<Type> {
			return json <| "type" >>- { (typeStr: String) in
				switch typeStr {
				case TypeString.digital.rawValue:
					return curry(Type.digital)
						<^> json <| ["free_download", "enabled"]
						<*> json <| ["free_download", "require_follow"] <|> pure(false)
					
				case TypeString.physical.rawValue:
					return curry(Type.physical)
						<^> json <|| "shipping_price_handlers"
						<*> json <|? "fulfiller"
					
				case TypeString.bundle.rawValue:
					return curry(Type.bundle)
						<^> json <| "living_bundle"
						<*> json <|| ["bundled_items", "store_items"] <|> pure([])
					
				case TypeString.experience.rawValue:
					return pure(.experience)
					
				case TypeString.giftCard.rawValue:
					return pure(.giftCard)
					
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
		public enum Type: Decodable {
			case Amount(Double)
			case Percentage(Double)
			
			public static func decode(json: JSON) -> Decoded<Type> {
				return json <| "sale_type" >>- { (type: String) in
					if type == "percent" {
						return Type.Percentage <^> json <| "sale_percentage"
					} else if type == "amount" {
						return Type.Amount <^> json <| "sale_amount"
					} else {
						return .customError("Unsupported store option sale type")
					}
				}
			}
		}
		public let type: Type
		public let startDate: NSDate
		public let endDate: NSDate
		
		public static func decode(json: JSON) -> Decoded<Sale> {
			return curry(Sale.init)
				<^> Type.decode(json)
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
	public let isExclusive: Bool
	public let isFeatured: Bool
	public let creationDate: NSDate
	public let creator: Expandable<User>
	public let modificationDate: NSDate
	public let modifier: Expandable<User>
	public let category: String?
	public let sale: Sale?
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
			<*> Decoded<Sale>.optional(Sale.decode(json))
			<*> json <|| "tags" <|> pure([])
			<*> json <| "fans_name_price"
			<*> json <|| "options" <|> pure([])
			<*> price
			<*> json <|? "photo"
			<*> json <|? "photos"
	}
}
