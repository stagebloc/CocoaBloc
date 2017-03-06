//
//  StoreItem.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//


public struct StoreItem: Identifiable {
	
	// MARK: Types
	
	public struct Option {
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
	}
	
	public enum ItemType {
		case digital(isFreeDownload: Bool, requiresFollow: Bool)
		case physical(shippingPriceHandlers: [Shipping.PriceHandler], fulfiller: Shipping.Fulfiller?)
		case bundle(isLivingBundle: Bool, storeItems: [StoreItem])//, audio: [Audio]/*, playlists */)
		case experience
		case giftCard
		
		enum TypeString: String {
			case digital	= "digital"
			case physical	= "physical"
			case bundle		= "bundle"
			case experience = "experience"
			case giftCard	= "gift card"
			case error		= "error"
		}
	}
	
	public enum Currency: String {
		case USD = "usd"
	}
	
	public struct Sale {
		public enum SaleType {
			case amount(Double)
			case percentage(Double)
		}
		
		public let type: SaleType
		public let startDate: Date
		public let endDate: Date
	}
	
	// MARK: Properties
	
	public let identifier: Int
	public let account: Expandable<Account>
	public let title: String
	public let shortURL: URL
	public let descriptiveText: String
	public let isSoldOut: Bool
	public let isExclusive: Bool
	public let isFeatured: Bool
//	public let creationDate: Date
//	public let creator: Expandable<User>
//	public let modificationDate: Date
//	public let modifier: Expandable<User>
	public let category: String?
	public let sale: Sale?
	public let tags: [String]
	public let isFansNamePrice: Bool
	public let options: [Option]
	public let priceUSD: Double
	public let coverPhoto: Expandable<AccountPhoto>?
	public let photos: ExpandableArray<AccountPhoto>?
	public let type: ItemType
	
	public var productIsOnSale: Bool {
		get {
			if let sale = sale {
				let now = Foundation.Date()
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
			} else if case .bundle(_, let items) = type {
				return ExpandableArray<AccountPhoto>.expanded(items.filter { $0.coverPhoto != nil && $0.coverPhoto!.value != nil }.map { $0.coverPhoto!.value! })
			}
			return nil
		}
	}
	
}
