//
//  SBContentStreamObject+ContentType.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/19/15.
//  Modified by Dan Zimmerman on 3/3/16
//  Copyright © 2015 StageBloc. All rights reserved.
//

/*
Extends SBContentStreamObject to allow it to be be used in API targets that require a ContentType.

Ex: API.LikeContent(mySBPhoto)
*/
extension SBContentStreamObject: ContentType {
	public var contentID: Int {
		return identifier.integerValue
	}
	
	public var postedAccountID: Int {
		return accountID.integerValue
	}
	
	public var contentType: API.ContentTypeIdentifier {
		switch self {
		case is SBPhoto:
			return .Photo
		case is SBBlog:
			return .Blog
		case is SBStatus:
			return .Status
		case is SBAudio:
			return .Audio
		case is SBVideo:
			return .Video
		case is SBEvent:
			return .Event
		default:
			return .Blog // won't be reached. compiler can't know that this dynamic check really is exhaustive
		}
	}
}