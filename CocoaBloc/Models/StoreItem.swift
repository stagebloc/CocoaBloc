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
	}
	
	public enum Currency: String {
		case USD = "usd"
	}
	
	public struct Sale {
		public enum SaleType {
			case Amount(Double)
			case Percentage(Double)
		}
		
		public let type: SaleType
		public let startDate: NSDate
		public let endDate: NSDate
	}
	
	// MARK: Properties
	
	public let identifier: Int
	public let type: ItemType
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
	
}
