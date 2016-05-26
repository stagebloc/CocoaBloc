//
//  API.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Alamofire

public struct API {
	
	public enum ExpandableValue: String {
		case Photo      = "photo"
		case Photos     = "photos"
		case Account    = "account"
		case User       = "user"
		case Tags       = "tags"
		case Audio      = "audio"
		case CreatedBy  = "created_by"
		case ModifiedBy = "modified_by"
		case Content    = "content"
	}
	
	public enum UserColor: String {
		case Blue   = "blue"
		case Teal   = "teal"
		case Green  = "green"
		case Pink   = "pink"
		case Red    = "red"
		case Purple = "purple"
	}
	
	public enum Gender: String {
		case Male       = "male"
		case Female     = "female"
		case Cupcake    = "cupcake"
	}
	
	public enum ContentTypeIdentifier: String {
		case Photo  = "photo"
		case Audio  = "audio"
		case Video  = "video"
		case Blog   = "blog"
		case Status = "status"
		case Event	= "event"
	}
	
	public enum ContentListType: String {
		case Update  = "updates"
		case Like  = "likes"
	}
	
	public enum AccountColor: String {
		case Blue       = "blue"
		case Purple     = "purple"
		case Red        = "red"
		case Orange     = "orange"
		case Grey       = "grey"
		case Green      = "green"
	}
	
	public enum AccountType: String {
		case Music              = "music"
		case FilmAndTV          = "film/tv"
		case Entertainment      = "entertainment"
		case Sports             = "sports"
		case Celebrity          = "celebrity"
		case Comedian           = "comedian"
		case RecordLabel        = "record label"
		case ManagementCompany  = "management company"
		case Personal           = "personal"
		case Developer          = "developer"
		case Photography        = "photography"
		case Cooking            = "food"
		case Business           = "business"
		case Organization       = "organization"
		case Other              = "other"
	}
	
	public enum FanClubType: String {
		case Featured   = "featured"
		case Recent     = "recent"
		case Following  = "following"
	}
	
	public enum FlagType: String {
		case Duplicate = "duplicate"
		case Copyright = "copyright"
		case Prejudice = "prejudice"
		case Offensive = "offensive"
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
