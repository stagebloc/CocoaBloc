//
//  FanClub.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct FanClub: Identifiable {
	
	public let identifier: Int
	public let title: String
	public let descriptiveText: String
	public let account: Expandable<Account>
	public let moderationQueue: Bool
	
}
