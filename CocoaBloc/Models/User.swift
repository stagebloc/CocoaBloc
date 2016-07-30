//
//  User.swift
//  CocoaBloc
//
//  Created by John Heaton on 5/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

public struct User: Identifiable {
	
	public let identifier: Int
	public let url: NSURL
	public let creationDate: NSDate
	public let name: String
	public let username: String
	public let bio: String
	public let photo: UserPhoto?
//	public let birthday: NSDate?
	public let gender: String?
	public let emailAddress: String?
	public let color: RGBComponents
	
}
