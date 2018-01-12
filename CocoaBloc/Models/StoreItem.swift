//
//  StoreItem.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public class Category {
	public var name: String
	public var subCategories: [Category]
	public var items: [StoreItem]
	
	public init(name: String, subCategories: [Category] = [], items: [StoreItem] = []) {
		self.name = name
		self.subCategories = subCategories
		self.items = items
	}
}

public struct StoreItem: APIObject {
	
	// MARK: Types
	
	public struct Option: Codable {
		public struct Price: Codable {
			public let currency: Currency
			public let price: Double
		}
		
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
		public let additionalPrice: [Price]?
		
		private enum CodingKeys: String, CodingKey {
			case name, sku, isDisabled = "disabled", upc, isUnlimited = "unlimited", quantity, isSoldOut = "sold_out", lowStockThreshold = "low_stock_threshold", weight, weightUnit = "weight_unit", height, width, length, additionalPrice = "additional_price"
		}
	}
	
	public enum ItemType: String, Codable {
		case digital
		case physical
		case bundle
		case experience
		case giftCard = "gift card"
	}
	
	public enum Currency: String, Codable {
		case USD = "usd"
	}
	
	public struct BundledItems: Codable {
		public let storeItems: [StoreItem]
		
		private enum CodingKeys: String, CodingKey {
			case storeItems = "store_items"
		}
	}
	
	public struct Sale {
		public enum SaleType {
//			public init(from decoder: Decoder) throws {
//				let container = try decoder.container(keyedBy: CodingKeys.self)
//				if let amount = try container.decodeIfPresent(Double.self, forKey: .amount) {
//					self = .amount(amount)
//				} else {
//					self = .percentage(try container.decode(Double.self, forKey: .percentage))
//				}
//			}
			
//			public func encode(to encoder: Encoder) throws {
//				var container = encoder.container(keyedBy: CodingKeys.self)
//				switch self {
//				case .amount(let amount):
//					try container.encode(amount, forKey: .amount)
//				case .percentage(let percentage):
//					try container.encode(percentage, forKey: .percentage)
//				}
//			}
			
			case amount(Double)
			case percentage(Double)
			
//			private enum CodingKeys: String, CodingKey {
//				case amount, percentage
//			}
		}
		
		public let type: SaleType
		public let startDate: Date
		public let endDate: Date
	}
	
	// MARK: Properties
	
	public let id: Int
	public let account: Expandable<Account>
	public let title: String
	public let shortURL: URL
	public let descriptiveText: String
	public let isSoldOut: Bool
	public let isExclusive: Bool
	public let isFeatured: Bool
	public let creationDate: Date
	public let creator: Expandable<User>
	public let modificationDate: Date
	public let modifier: Expandable<User>
	public let category: String?
	public var advancedCategories: Category?
	public let sale: Sale?
	public let tags: [String]?
	public let isFansNamePrice: Bool
	public let options: [Option]?
	public let priceUSD: Double
	public let coverPhoto: Expandable<AccountPhoto>?
	public let photos: ExpandableArray<AccountPhoto>?
	public let type: ItemType
	public let livingBundle: Bool?
	public let bundledItems: BundledItems?
//	public let freeDownload: Bool?
	public let requireFollow: Bool?
	public let shippingPriceHandlers: [Shipping.PriceHandler]?
	public let fulfiller: Shipping.Fulfiller?
	
	public var productIsOnSale: Bool {
		get {
			if let sale = sale {
				let now = Date()
				return (sale.startDate as NSDate).earlierDate(now) == sale.startDate
					&& (sale.endDate as NSDate).laterDate(now) == sale.endDate
			} else { return false }
		}
	}
	
	public var productSalePrice: Double {
		get {
			if let sale = sale {
				switch sale.type {
				case .amount(let amount):
					return priceUSD - amount
				case .percentage(let percentage):
					return priceUSD * (100.0 - percentage) / 100.0
				}
			} else { return priceUSD }
		}
	}
	
	public var productCoverPhoto: ExpandableArray<AccountPhoto>? {
		get {
			if let coverPhoto = coverPhoto {
				return ExpandableArray<AccountPhoto>.expanded([coverPhoto.value!])
			} else if let items = bundledItems?.storeItems {
				return ExpandableArray<AccountPhoto>.expanded(items.filter { $0.coverPhoto != nil && $0.coverPhoto!.value != nil }.map { $0.coverPhoto!.value! })
			}
			return nil
		}
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		creationDate = try values.decode(Date.self, forKey: .creationDate)
		modificationDate = try values.decode(Date.self, forKey: .modificationDate)
		if try values.decodeIfPresent(Bool.self, forKey: .onSale) ?? false {
			let saleStart = try values.decode(Date.self, forKey: .saleStart)
			let saleEnd = try values.decode(Date.self, forKey: .saleEnd)
			if let amount = try values.decodeIfPresent(Double.self, forKey: .saleAmount) {
				sale = Sale(type: .amount(amount), startDate: saleStart, endDate: saleEnd)
			} else if let percentage = try values.decodeIfPresent(Double.self, forKey: .salePercentage) {
				sale = Sale(type: .percentage(percentage), startDate: saleStart, endDate: saleEnd)
			} else {
				sale = nil
			}
		} else {
			sale = nil
		}
		account = try values.decode(Expandable<Account>.self, forKey: .account)
		creator = try values.decode(Expandable<User>.self, forKey: .creator)
		modifier = try values.decode(Expandable<User>.self, forKey: .modifier)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		descriptiveText = try values.decode(String.self, forKey: .descriptiveText)
		title = try values.decode(String.self, forKey: .title)
		shortURL = try values.decode(URL.self, forKey: .shortURL)
		tags = try values.decodeIfPresent([String].self, forKey: .tags)
		isFansNamePrice = try values.decode(Bool.self, forKey: .isFansNamePrice)
		isSoldOut = try values.decode(Bool.self, forKey: .isSoldOut)
		isExclusive = try values.decode(Bool.self, forKey: .isExclusive)
		isFeatured = try values.decode(Bool.self, forKey: .isFeatured)
		options = try values.decodeIfPresent([Option].self, forKey: .options)
		priceUSD = try values.decode(Double.self, forKey: .priceUSD)
		coverPhoto = try values.decodeIfPresent(Expandable<AccountPhoto>.self, forKey: .coverPhoto)
		photos = try values.decodeIfPresent(ExpandableArray<AccountPhoto>.self, forKey: .photos)
		type = try values.decode(ItemType.self, forKey: .type)
		livingBundle = try values.decodeIfPresent(Bool.self, forKey: .livingBundle)
		bundledItems = try values.decodeIfPresent(BundledItems.self, forKey: .bundledItems)
//		freeDownload = try values.decodeIfPresent(Bool.self, forKey: .freeDownload)
		requireFollow = try values.decodeIfPresent(Bool.self, forKey: .requireFollow)
		shippingPriceHandlers = try values.decodeIfPresent([Shipping.PriceHandler].self, forKey: .shippingPriceHandlers)
		fulfiller = try values.decodeIfPresent(Shipping.Fulfiller.self, forKey: .fulfiller)
		
		if let category = category {
			if !category.isEmpty {//.contains(">") {
				var categories: [String] = category.split(separator: ">").map { String($0) }
				advancedCategories = Category.init(name: categories.removeFirst())
				var tmp: Category?
				if !categories.isEmpty {
					advancedCategories?.subCategories = [Category.init(name: categories.removeFirst())]
					tmp = advancedCategories!.subCategories[0]
				}
				while !categories.isEmpty {
					tmp!.subCategories = [Category.init(name: categories.removeFirst())]
					tmp = tmp!.subCategories[0]
				}
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(
			keyedBy: CodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(account, forKey: .account)
		try container.encode(title, forKey: .title)
		try container.encode(shortURL, forKey: .shortURL)
		try container.encode(descriptiveText, forKey: .descriptiveText)
		try container.encode(isSoldOut, forKey: .isSoldOut)
		try container.encode(isFansNamePrice, forKey: .isFansNamePrice)
		try container.encode(isFeatured, forKey: .isFeatured)
		try container.encode(isExclusive, forKey: .isExclusive)
		try container.encode(creator, forKey: .creator)
		try container.encode(modifier, forKey: .modifier)
		try container.encode(category, forKey: .category)
		try container.encode(tags, forKey: .tags)
		try container.encodeIfPresent(options, forKey: .options)
		try container.encodeIfPresent(livingBundle, forKey: .livingBundle)
		try container.encode(priceUSD, forKey: .priceUSD)
		try container.encode(type, forKey: .type)
		try container.encodeIfPresent(coverPhoto, forKey: .coverPhoto)
		try container.encodeIfPresent(photos, forKey: .photos)
		try container.encode(type, forKey: .type)
//		try container.encodeIfPresent(freeDownload, forKey: .freeDownload)
		try container.encodeIfPresent(requireFollow, forKey: .requireFollow)
		try container.encodeIfPresent(shippingPriceHandlers, forKey: .shippingPriceHandlers)
		try container.encodeIfPresent(fulfiller, forKey: .fulfiller)
		try container.encode(modificationDate, forKey: .modificationDate)
		try container.encode(creationDate, forKey: .creationDate)
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, account, creationDate = "created", title, modificationDate = "modified", category, shortURL = "short_url", descriptiveText = "description", isSoldOut = "sold_out", isFeatured = "featured", isExclusive = "exclusive", creator = "created_by", modifier = "modified_by", sale, tags, isFansNamePrice = "fans_name_price", options, priceUSD = "price", coverPhoto = "photo", photos, type, livingBundle = "living_bundle", freeDownload = "free_download", requireFollow = "require_follow", shippingPriceHandlers = "shipping_price_handler", fulfiller, bundledItems = "bundled_items", onSale = "on_sale", saleEnd = "sale_end_date", saleStart = "sale_start_date", saleAmount = "sale_amount", salePercentage = "sale_percentage"
	}
}
