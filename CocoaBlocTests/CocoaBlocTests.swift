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
	
	let client = Client(clientID: "de4346e640860eb3d6fd97e11e475d0d", clientSecret: "c2288f625407c5aff55e41d1fef1ed73")
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

	func testStoreItems() {
		client.request(API.getStoreItemsForAccount(2912)) { response in
			if let items = response.result.value {
				
			} else {
				
			}
		}
		
		let x = expectationWithDescription("asdf")
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
}
