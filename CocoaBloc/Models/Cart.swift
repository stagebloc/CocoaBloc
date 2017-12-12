//
//  Cart.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Cart: APIObject {
	
	public struct Item: Codable {
		public let id: Int
		public let cartID: Int
		public let creationDate: Date
		public let hash: String
		public let productID: Int
		public let productType: String
		public let namedPrice: String?
		public let quantity: Int
		public let details: String
		public let status: String
		public let sku: String
		public let parentID: Int?
		public let lockExpires: Date?
		
		private struct Product: Codable {
			public let id: Int
			public let type: String
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			id = try values.decode(Int.self, forKey: .id)
			cartID = try values.decode(Int.self, forKey: .cartID)
			hash = try values.decode(String.self, forKey: .hash)
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			guard let creation = try formatter.date(from: values.decode(String.self, forKey: .creationDate)) else {
				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.creationDate], debugDescription: "Expecting string representation of Date"))
			}
			do {
				let product = try values.decode(Product.self, forKey: .product)
				productID = product.id
				productType = product.type
			} catch {
				productID = -1
				productType = "Error"
			}
			creationDate = creation
			namedPrice = try values.decodeIfPresent(String.self, forKey: .namedPrice)
			quantity = try values.decode(Int.self, forKey: .quantity)
			status = try values.decode(String.self, forKey: .status)
			details = try values.decode(String.self, forKey: .details)
			sku = try values.decode(String.self, forKey: .sku)
			parentID = try values.decodeIfPresent(Int.self, forKey: .parentID)
			if let expires = try formatter.date(from: values.decodeIfPresent(String.self, forKey: .lockExpires) ?? "") {
				lockExpires = expires
			} else {
				lockExpires = nil
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(
				keyedBy: CodingKeys.self)
			
			let product = Product(id: productID, type: productType)
			try container.encode(product, forKey: .product)
			
			try container.encode(id, forKey: .id)
			try container.encode(cartID, forKey: .cartID)
			try container.encode(creationDate, forKey: .creationDate)
			try container.encode(hash, forKey: .hash)
			try container.encodeIfPresent(namedPrice, forKey: .namedPrice)
			try container.encode(quantity, forKey: .quantity)
			try container.encode(details, forKey: .details)
			try container.encode(status, forKey: .status)
			try container.encode(sku, forKey: .sku)
			try container.encodeIfPresent(parentID, forKey: .parentID)
			try container.encodeIfPresent(lockExpires, forKey: .lockExpires)
		}
		
		private enum CodingKeys: String, CodingKey {
			case id, cartID = "cart", creationDate = "created", hash, product, namedPrice = "named_price", quantity, status, parentID = "parent_id", lockExpires = "lock_expires", details, sku
		}
	}
	
	public struct Totals: Codable {
		public let items: Double
		public let subtotal: Double
		public let total: Double
		public let shipping: Double
		public let revenueShare: [String:Double]?
		public let couponDiscount: Double?
		public let taxes: Double?
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			
			do {
				revenueShare = try values.decodeIfPresent([String:Double].self, forKey: .revenueShare)
			} catch {
				revenueShare = nil
			}
			
			taxes = try values.decode(Double.self, forKey: .taxes)
			items = try values.decode(Double.self, forKey: .items)
			subtotal = try values.decode(Double.self, forKey: .subtotal)
			total = try values.decode(Double.self, forKey: .total)
			shipping = try values.decode(Double.self, forKey: .shipping)
			
			do {
				couponDiscount = try values.decodeIfPresent(Double.self, forKey: .couponDiscount)
			} catch {
				couponDiscount = nil
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case couponDiscount = "discounts", taxes, items, subtotal, total, shipping, revenueShare = "revenue_share"
		}
	}
	
	public enum Status: String, Codable {
		case started			= "started"
		case reachedCheckout	= "reached_checkout"
		case completedCheckout	= "completed_checkout"
	}
	
	public let id: Int
	public let userID: Int
	public let user: User?
	public let sessionID: String
	public let creationDate: Date
	public let emailAddress: String?
	public let coupons: [String]
	public let status: Status
	public let items: [Item]
	public let shippingAddress: Address?
	public let totals: Totals
	public let shippingRates: Shipping.RateSet?
	public let shippingSelected: Shipping.SelectionSet?
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		userID = try values.decode(Int.self, forKey: .userID)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		sessionID = try values.decode(String.self, forKey: .sessionID)
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		guard let creation = try formatter.date(from: values.decode(String.self, forKey: .creationDate)) else {
			throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.creationDate], debugDescription: "Expecting string representation of Date"))
		}
		creationDate = creation
		emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
		coupons = try values.decode([String].self, forKey: .coupons)
		status = try values.decode(Status.self, forKey: .status)
		do {
			items = try Array(values.decode([String:Item].self, forKey: .items).values)
		} catch let error {
			debugPrint(error)
			items = [] 
			
		}
		shippingAddress = try values.decodeIfPresent(Address.self, forKey: .shippingAddress)
		totals = try values.decode(Totals.self, forKey: .totals)
		shippingRates = try values.decodeIfPresent(Shipping.RateSet.self, forKey: .shippingRates)
		shippingSelected = try values.decodeIfPresent(Shipping.SelectionSet.self, forKey: .shippingSelected)
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, userID = "user_id", user, sessionID = "session_id", creationDate = "created", emailAddress = "email", coupons = "coupon_code", status, items = "cart_items", shippingAddress = "shipping_address", totals, shippingRates = "shipping_rates", shippingSelected = "shipping_selected"
	}
}

private struct PostCart: Codable {
	public struct Shipping: Codable {
		public let shipping: Address
	}
	public struct Cart: Codable {
		public let addresses: PostCart.Shipping?
		public let session_id: String?
		public let user_id: Int?
		public let email: String?
		public let coupon: [String]?
		
		public init(addresses: PostCart.Shipping? = nil, session_id: String? = nil, user_id: Int? = nil, email: String? = nil, coupon: [String]? = nil) {
			self.addresses = addresses
			self.session_id = session_id
			self.user_id = user_id
			self.email = email
			self.coupon = coupon
		}
	}
	public let cart: PostCart.Cart
	public let expand: String = ""
}

private struct PostShipping: Codable {
	public struct Order: Codable {
		public let order: [Shipping.Selection]
	}
	public struct Cart: Codable {
		public let session_id: String
		public let shipping_override: Order?
		public let shipping_details: Order?
	}
	public let cart: PostShipping.Cart
	public let expand: String = ""
}

private struct PostItem: Codable {
	public struct Item: Codable {
		public let type: String
		public let id: Int
		public let sku: String?
		public let quantity: Int?
	}
	public let item: Item
	public let expand: String = ""
}

private struct PostPurchase: Codable {
	public let payments: [Client.Payment]
	public let tax: Double?
	public let phone: String?
	public let notes: String?
	public let adminID: String
	public let deviceID: String
	public let applicationMode: String
	public let expand: String = ""
	
	private enum CodingKeys: String, CodingKey {
		case payments, tax = "tax_override", phone = "phone_number", notes, adminID = "admin_id", deviceID = "device_identifier", applicationMode = "application_mode", expand
	}
}

extension Client {
	public func getCart(withSessionIdentifier cartSessionID: String, completionHandler: @escaping (Cart?, Error?) -> Void) {
		get(withEndPoint: "cart/\(cartSessionID)", completionHandler: completionHandler)
	}
	
	public func createCart(withEmail email: String? = nil, userID: Int? = nil, venue: Address? = nil, completionHandler: @escaping (Cart?, Error?) -> Void) {
		if let venue = venue {
			let newCart = PostCart(cart: PostCart.Cart(addresses: PostCart.Shipping(shipping: venue), session_id: nil, user_id: userID, email: email, coupon: nil))
			
			do {
				let encoder = JSONEncoder()
				let newCartJSON = try encoder.encode(newCart)
				post(withEndPoint: "cart", postJSON: newCartJSON, completionHandler: completionHandler)
			} catch {
				completionHandler(nil, error)
			}
		} else {
			post(withEndPoint: "cart", completionHandler: completionHandler)
		}
	}
	
	public func updateCart(withSessionIdentifier cartSessionID: String, newEmail: String? = nil, newShippingAddress: Address? = nil, completionHandler: @escaping (Cart?, Error?) -> Void) {
		let updatedCart = PostCart(cart: PostCart.Cart(addresses: (newShippingAddress != nil ? PostCart.Shipping(shipping: newShippingAddress!) : nil), session_id: cartSessionID, user_id: nil, email: newEmail, coupon: nil))
		do {
			let encoder = JSONEncoder()
			let updatedCartJSON = try encoder.encode(updatedCart)
			post(withEndPoint: "cart/\(cartSessionID)", postJSON: updatedCartJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func updateCart(withSessionIdentifier cartSessionID: String, shippingInfo: Shipping.Selection, overrideShipping: Bool = false, completionHandler: @escaping (Cart?, Error?) -> Void) {
		let updateShipping: PostShipping
		if overrideShipping {
			updateShipping = PostShipping(cart: PostShipping.Cart(session_id: cartSessionID, shipping_override:
				PostShipping.Order(order: [shippingInfo]), shipping_details: nil))
		} else {
			updateShipping = PostShipping(cart: PostShipping.Cart(session_id: cartSessionID, shipping_override:
				nil, shipping_details: PostShipping.Order(order: [shippingInfo])))
		}
		do {
			let encoder = JSONEncoder()
			let updateShippingJSON = try encoder.encode(updateShipping)
			post(withEndPoint: "cart/\(cartSessionID)", postJSON: updateShippingJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func addItemToCart(withSessionIdentifier cartSessionID: String, storeItemIdentifier storeItemID: Int, sku: String, quantity: Int, completionHandler: @escaping (Cart?, Error?) -> Void) {
		let postItem = PostItem(item: PostItem.Item(type: "store", id: storeItemID, sku: sku, quantity: quantity))
		do {
			let encoder = JSONEncoder()
			let postItemJSON = try encoder.encode(postItem)
			post(withEndPoint: "cart/\(cartSessionID)/items", postJSON: postItemJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func updateItemInCart(withSessionIdentifier cartSessionID: String, storeItemID: Int, cartItemHash: String, sku: String?, quantity: Int?, completionHandler: @escaping (Cart?, Error?) -> Void) {
		let postItem = PostItem(item: PostItem.Item(type: "store", id: storeItemID, sku: sku, quantity: quantity))
		do {
			let encoder = JSONEncoder()
			let postItemJSON = try encoder.encode(postItem)
			post(withEndPoint: "cart/\(cartSessionID)/items/\(cartItemHash)", postJSON: postItemJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func deleteItemInCart(
		withHash cartItemHash: String,
		fromCartWithSessionIdentifier cartSessionID: String, completionHandler: @escaping (Cart?, Error?) -> Void) {
		delete(withEndPoint: "cart/\(cartSessionID)/items/\(cartItemHash)", completionHandler: completionHandler)
	}
	
	//	public func deleteAddressCart(
	//		withHash cartItemHash: String,
	//		fromCartWithSessionIdentifier cartSessionID: String, completionHandler: @escaping (Cart?, Error?) -> Void) {
	//		guard let url = urlForEndpoint("cart/\(cartSessionID)/items/\(cartItemHash)") else {
	//			print("Error: cannot create URL")
	//			let error = APIError.system("Error: cannot create URL")
	//			completionHandler(nil, error)
	//			return
	//		}
	//		var urlRequest = URLRequest(url: url)
	//		urlRequest.httpMethod = "DELETE"
	//
	//		request(with: urlRequest, completionHandler: completionHandler)
	//	}
	
	public struct Payment: Codable {
		
		public enum PaymentType {
			case cash
			case giftCard
			case stripe(token: String)
			case stripeCharge(id: String)
			case credit
			case error
		}
		
		public var type: PaymentType
		public var amount: Double
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			if let processor = try container.decodeIfPresent(String.self, forKey: .payment_processor) {
				if processor == CodingKeys.cash.rawValue {
					type = .cash
				} else if processor == CodingKeys.credit.rawValue {
					type = .credit
				} else if processor == CodingKeys.giftCard.rawValue {
					type = .giftCard
				} else if let token = try container.decodeIfPresent(String.self, forKey: .token) {
					type = .stripe(token: token)
				} else if let id = try container.decodeIfPresent(String.self, forKey: .charge_id) {
					type = .stripeCharge(id: id)
				} else {
					type = .error
				}
			} else {
				type = .error
			}
			amount = try container.decode(Double.self, forKey: .amount)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(amount, forKey: .amount)
			switch type {
			case .cash:
				try container.encode("cash", forKey: .payment_processor)
			case .giftCard:
				try container.encode("gift", forKey: .payment_processor)
			case .credit:
				try container.encode("credit", forKey: .payment_processor)
			case .stripe(let token):
				try container.encode("STRIPE", forKey: .payment_processor)
				try container.encode(token, forKey: .token)
			case .stripeCharge(let id):
				try container.encode("STRIPE", forKey: .payment_processor)
				try container.encode(id, forKey: .charge_id)
			case .error:
				break
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case cash, giftCard = "gift_card", stripe = "STRIPE", stripeCharge, credit, payment_processor, token, charge_id, amount
		}
		
		public init(type: PaymentType, amount: Double) {
			self.type = type
			self.amount = amount
		}
		
	}
	
	public func purchaseCart(withSessionIdentifier cartSessionID: String, payments: [Payment], tax: Double? = nil, phone: String? = nil, deviceID: String = "", accountID: String = "", offline: Bool = false, notes: String? = nil, completionHandler: @escaping ([Order]?, Error?) -> Void) {
		let postPurchase = PostPurchase(payments: payments, tax: tax, phone: phone, notes: notes, adminID: accountID, deviceID: deviceID, applicationMode: (offline ? "offline" : "online"))
		do {
			let encoder = JSONEncoder()
			let postPurchaseJSON = try encoder.encode(postPurchase)
			post(withEndPoint: "cart/\(cartSessionID)/purchase", postJSON: postPurchaseJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
	
	public func updateCoupon(withSessionIdentifier cartSessionID: String, coupon: String = "", completionHandler: @escaping (Cart?, Error?) -> Void) {
		let postCart = PostCart(cart: PostCart.Cart(addresses: nil, session_id: cartSessionID, user_id: nil, email: nil, coupon: [coupon]))
		do {
			let encoder = JSONEncoder()
			let postCartJSON = try encoder.encode(postCart)
			post(withEndPoint: "cart/\(cartSessionID)/purchase", postJSON: postCartJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
}

