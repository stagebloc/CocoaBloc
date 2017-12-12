//
//  Order.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct Order: APIObject {
	
	public let id: Int
	public let account: Expandable<Account>
	public let receiptURL: URL
	public let orderDate: Date
	public let isShipped: Bool
	public let currency: StoreItem.Currency
	public let total: Double
	public let totalUSD: Double
	public let shippingAmount: Double
	public let phone: String
	public let handlingAmount: Double
	public let savedAmount: Double
	public let taxAmount: Double
	public let status: String
	public let notes: String?
	public let device: String?
	public let source: String?
	public let mode: String // TODO make enum
	public let emailAddress: String
	public let user: User?
	public let address: Address?
	public let transactions: [Transaction]
	
	public struct Shipment: Codable {
		public let id: Int
		public let trackingNumber: String
		public let shippedDate: Date
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			id = try values.decode(Int.self, forKey: .id)
			trackingNumber = try values.decode(String.self, forKey: .trackingNumber)

			shippedDate = try values.decode(Date.self, forKey: .shippedDate)
//			let formatter = DateFormatter()
//			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//			guard let shipped = try formatter.date(from: values.decode(String.self, forKey: .shippedDate)) else {
//				throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.shippedDate], debugDescription: "Expecting string representation of Date"))
//			}
//			shippedDate = shipped
		}
		
		private enum CodingKeys: String, CodingKey {
			case id, shippedDate = "shipped", trackingNumber = "tracking_number"
		}
	}
	
	public struct Item: Codable {
		public let type: String
		public let object: StoreItem
	}
	
	public struct Transaction: Codable {
		public let id: Int
		public let modificationDate: Date?
		public let amount: Double
		public let status: String
		public let quantity: Int
		public let sku: String
		public let shipment: Order.Shipment?
		public let item: Order.Item?
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			id = try values.decode(Int.self, forKey: .id)
			modificationDate = try values.decodeIfPresent(Date.self, forKey: .modificationDate)
//			let formatter = DateFormatter()
//			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//			if let modification = try formatter.date(from: values.decode(String.self, forKey: .modificationDate)) {
//				modificationDate = modification
//			} else { modificationDate = nil }
			amount = try values.decode(Double.self, forKey: .amount)
			quantity = try values.decode(Int.self, forKey: .quantity)
			shipment = try values.decodeIfPresent(Order.Shipment.self, forKey: .shipment)
			item = try values.decodeIfPresent(Order.Item.self, forKey: .item)
			sku = try values.decode(String.self, forKey: .sku)
			status = try values.decode(String.self, forKey: .status)
		}
		
		private enum CodingKeys: String, CodingKey {
			case id, modificationDate = "modified", amount, quantity, shipment, item, sku, status
		}
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		account = try values.decode(Expandable<Account>.self, forKey: .account)

		orderDate = try values.decode(Date.self, forKey: .orderDate)
//		let formatter = DateFormatter()
//		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//		guard let order = try formatter.date(from: values.decode(String.self, forKey: .orderDate)) else {
//			throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.orderDate], debugDescription: "Expecting string representation of Date"))
//		}
//		orderDate = order
		receiptURL = try values.decode(URL.self, forKey: .receiptURL)
		do {
			isShipped = try values.decode(Bool.self, forKey: .isShipped)
		} catch {
			isShipped = true
		}
		currency = try values.decode(StoreItem.Currency.self, forKey: .currency)

		total = try values.decode(Double.self, forKey: .total)
		totalUSD = try values.decode(Double.self, forKey: .totalUSD)
		shippingAmount = try values.decode(Double.self, forKey: .shippingAmount)
		handlingAmount = try values.decode(Double.self, forKey: .handlingAmount)
		savedAmount = try values.decode(Double.self, forKey: .savedAmount)
		taxAmount = try values.decode(Double.self, forKey: .taxAmount)
		phone = try values.decode(String.self, forKey: .phone)
		status = try values.decode(String.self, forKey: .status)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		device = try values.decodeIfPresent(String.self, forKey: .device)
		source = try values.decodeIfPresent(String.self, forKey: .source)
		emailAddress = try values.decode(String.self, forKey: .emailAddress)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		address = try values.decodeIfPresent(Address.self, forKey: .address)
		transactions = try values.decode([Transaction].self, forKey: .transactions)
		mode = try values.decode(String.self, forKey: .mode)
	}
	
	private enum CodingKeys: String, CodingKey {
		case id, account, receiptURL = "receipt_url", orderDate = "ordered", phone = "phone_number", isShipped = "shipped", currency, total, totalUSD = "total_usd", shippingAmount = "shipping_amount", handlingAmount = "handling_amount", savedAmount = "saved_amount", taxAmount = "tax_amount", status, notes, mode, device, source, emailAddress = "email", user, address, transactions
	}
}
