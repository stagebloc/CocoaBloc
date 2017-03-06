//
//  FanClub.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct FanClub {
	
	public struct Tier {
		public enum TimeUnit: String {
			case once	= "once"
			case month	= "month"
			case year	= "year"
		}
		
		public let title: String
		public let description: String
		public let price: Double
		public let discount: Double
		public let membershipLength: Int
		public let membershipLengthUnit: TimeUnit
		public let renewalPrice: Double?
	}
	
	public let title: String
	public let descriptiveText: String
	public let account: Expandable<Account>
	public let moderationQueue: Bool
	public let tiers: [Tier]
}
