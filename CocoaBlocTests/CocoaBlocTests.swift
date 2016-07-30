//
//  CocoaBlocTests.swift
//  CocoaBlocTests
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import XCTest
@testable import CocoaBloc
import Alamofire

class CocoaBlocTests: XCTestCase {
	
	// Test user and OAuth credentials
	let username = "hi@stagebloc.com"
	let password = "starwars"
	let client = Client(
		clientID: "f38a73215b9da926c7c7614f6245b87d",
		clientSecret: "799390cb946334e71db05eac33bd9f55"
//		baseURL: NSURL(string: "https://api.hermes.staging.public.stagebloc.co/v1")! // staging server
	)
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testNilValueDictionaryFiltering() {
		let value: [String: AnyObject?] = [
			"a": nil,
			"b": 1,
			"c": "test",
			"d": nil
		]
		let filtered = value.filterEntriesWithNilValues()
		
		XCTAssertNil(filtered.indexForKey("a"))
		XCTAssertNil(filtered.indexForKey("d"))
		XCTAssertEqual(filtered["b"] as? Int, 1)
		XCTAssertEqual(filtered["c"] as? String, "test")
	}

}
