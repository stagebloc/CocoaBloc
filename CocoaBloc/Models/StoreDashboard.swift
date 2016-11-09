//
//  StoreDashboard.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2016-11-04.
//  Copyright © 2016 StageBloc. All rights reserved.
//

public struct StoreDashboard {
	
	public let kind: String
	public let totals: Totals
	public let revenue: Revenue
	public let averages: Averages
	
	public struct Totals {
		public let revenue: Double
		public let shippingHandling: Double
		public let tax: Double
		public let orders: Int
	}
	
	public struct Revenue {
		public let store: Double
		public let fanClub: Double
	}
	
	public struct Averages {
		public let orderPrice: Double
		public let fanValue: Double
	}
	
}
