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

	func testStoreItems() {
		let x = expectationWithDescription("Store items should load")
		let y = expectationWithDescription("Store items for invalid account should not load")

		client.request(API.getStoreItemsForAccount(withIdentifier: 2912)) { response in
			if let items = response.result.value {
				x.fulfill()
			} else {
				XCTFail()
			}
		}
		
		client.request(API.getStoreItemsForAccount(withIdentifier: 0)) { response in
			if case .Failure = response.result {
				y.fulfill()
			} else {
				XCTFail()
			}
		}
		
		waitForExpectationsWithTimeout(10, handler: nil)
	}
	
}
