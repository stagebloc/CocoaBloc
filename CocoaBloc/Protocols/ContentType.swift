//
//  ContentType.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/19/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

/// Protocol describing a type containing necessary information to reference
/// a piece of content through the Fullscreen Direct API.
public protocol ContentType {
	
	/// Which type of content the identifier belongs to
	var contentType: API.ContentTypeIdentifier { get }
	
	/// The identifier of the content itself
	var contentID: Int { get }
	
	/// The identifier of the account on which this content is posted
	var postedAccountID: Int { get }
}
