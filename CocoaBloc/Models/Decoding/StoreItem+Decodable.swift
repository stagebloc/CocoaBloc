//
//  StoreItem+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension StoreItem: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<StoreItem> {
		let price: Decoded<Double> = decodedJSON(json, forKey: "prices").flatMap { priceJSON in
			switch priceJSON {
			case .array(let priceEntriesJSON):
				return priceEntriesJSON.first! <| "price"
			default:
				return .missingKey("price")
			}
		}
		let type: Decoded<StoreItem.ItemType> = ItemType.decode(json)
		
		let a = curry(StoreItem.init)
			<^> json <| "id"
			<*> json <| "account"
			<*> json <| "title"
			<*> json <| "short_url"
			<*> json <| "description"
			<*> json <| "sold_out"
			<*> json <| "exclusive"
			<*> json <| "featured"
		return a
//			<*> json <| "created"
//			<*> json <| "created_by"
//			<*> json <| "modified"
//			<*> json <| "modified_by"
			<*> json <|? "category"
			<*> Decoded<Sale>.optional(Sale.decode(json))
			<*> (json <|| "tags" <|> pure([]))
			<*> json <| "fans_name_price"
			<*> (json <|| "options" <|> pure([]))
			<*> price
			<*> json <|? "photo"
			<*> json <|? "photos"
			<*> type
	}

}

extension StoreItem.Option: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<StoreItem.Option> {
		let price: Decoded<Double?> = .optional(decodedJSON(json, forKey: "additional_price").flatMap { priceJSON in
			switch priceJSON {
			case .array(let priceEntriesJSON):
				return priceEntriesJSON.first! <| "price"
			default:
				return .missingKey("price")
			}
		})
		
		let a = curry(StoreItem.Option.init)
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

extension StoreItem.ItemType: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<StoreItem.ItemType> {
		return json <| "type" >>- { (typeStr: String) in
			switch TypeString(rawValue: typeStr) ?? .error {
			case .digital:
				return curry(StoreItem.ItemType.digital)
					<^> json <| ["free_download", "enabled"]
					<*> (json <| ["free_download", "require_follow"] <|> pure(true))// pure(false)
				
			case .physical:
				return curry(StoreItem.ItemType.physical)
					<^> json <|| "shipping_price_handlers"
					<*> json <|? "fulfiller"
				
			case .bundle:
				return curry(StoreItem.ItemType.bundle)
					<^> json <| "living_bundle"
					<*> (json <|| ["bundled_items", "store_items"] <|> pure([]))
				
			case .experience:
				return pure(StoreItem.ItemType.experience)
				
			case .giftCard:
				return pure(StoreItem.ItemType.giftCard)
				
			default:
				return .customError("Unexpected store item type: \(typeStr)")
			}
		}
	}

}

extension StoreItem.Sale: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<StoreItem.Sale> {
		return curry(StoreItem.Sale.init)
			<^> SaleType.decode(json)
			<*> json <| "sale_start_date"
			<*> json <| "sale_end_date"
	}

}

extension StoreItem.Sale.SaleType: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<StoreItem.Sale.SaleType> {
		return json <| "sale_type" >>- { (type: String) in
			if type == "percent" {
				return StoreItem.Sale.SaleType.percentage <^> json <| "sale_percentage"
			} else if type == "amount" {
				return StoreItem.Sale.SaleType.amount <^> json <| "sale_amount"
			} else {
				return .customError("Unsupported store option sale type")
			}
		}
	}

}

extension StoreItem.Currency: Decodable { }
