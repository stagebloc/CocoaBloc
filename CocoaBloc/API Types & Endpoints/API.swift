//
//  API.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import Foundation
import Alamofire

public struct API {
	
	public enum ExpandableValue: String {
		case photo      = "photo"
		case photos     = "photos"
		case account    = "account"
		case user       = "user"
		case tags       = "tags"
		case audio      = "audio"
		case createdBy  = "created_by"
		case modifiedBy = "modified_by"
		case content    = "content"
	}
	
	public enum UserColor: String {
		case blue   = "blue"
		case teal   = "teal"
		case green  = "green"
		case pink   = "pink"
		case red    = "red"
		case purple = "purple"
	}
	
	public enum Gender: String {
		case male		= "male"
		case female		= "female"
		case cupcake	= "cupcake"
	}
	
	public enum ContentTypeIdentifier: String {
		case photo  = "photo"
		case audio  = "audio"
		case video  = "video"
		case blog   = "blog"
		case status = "status"
		case event	= "event"
		case store	= "store"
	}
	
	public enum ContentListType: String {
		case update	= "updates"
		case like	= "likes"
	}
	
	public enum AccountColor: String {
		case blue       = "blue"
		case purple     = "purple"
		case red        = "red"
		case orange     = "orange"
		case grey       = "grey"
		case green      = "green"
	}
	
	public enum AccountType: String {
		case music				= "music"
		case filmAndTV			= "film/tv"
		case entertainment		= "entertainment"
		case sports				= "sports"
		case celebrity			= "celebrity"
		case comedian			= "comedian"
		case recordLabel		= "record label"
		case managementCompany	= "management company"
		case personal			= "personal"
		case developer			= "developer"
		case photography		= "photography"
		case cooking			= "food"
		case business			= "business"
		case organization		= "organization"
		case other				= "other"
	}
	
	public enum FanClubType: String {
		case featured   = "featured"
		case recent     = "recent"
		case following  = "following"
	}
	
	public enum FlagType: String {
		case duplicate = "duplicate"
		case copyright = "copyright"
		case prejudice = "prejudice"
		case offensive = "offensive"
	}
	
	public struct Content: ContentType {
		public let contentType: ContentTypeIdentifier
		public let contentID: Int
		public let postedAccountID: Int
	}
	
	static func DateFormatter(withTimeZone withTimeZone: Bool) -> NSDateFormatter {
		let ret = NSDateFormatter()
		ret.locale = NSLocale(localeIdentifier: "EN_US_POSIX")
		ret.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		ret.dateFormat = withTimeZone
			? "yyyy-MM-dd HH:mm:ss XXX"
			: "yyyy-MM-dd HH:mm:ss"
		return ret
	}
	
}
