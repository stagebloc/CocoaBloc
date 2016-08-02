//
//  CocoaBlocTests.swift
//  CocoaBlocTests
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 Fullscreen Direct. All rights reserved.
//

import XCTest
import Argo
@testable import CocoaBloc
import Alamofire

class CocoaBlocTests: XCTestCase {
	
	// Test OAuth credentials
	let username = "hi@stagebloc.com"
	let password = "starwars"
	
	// Configuration
	let requestTimeout: NSTimeInterval = 10
	
	// API client, fresh per test
	private(set) var client: Client<CallbackAuthenticationStateContainer>!

	// Test values
	let testErrorInfo = API.ErrorInfo(
		type: .invalidData,
		descriptiveText: "Invalid data",
		devNotes: "Fix your code"
	)
	
	override func setUp() {
		super.setUp()

		client = Client(
			clientID: "f38a73215b9da926c7c7614f6245b87d",
			clientSecret: "799390cb946334e71db05eac33bd9f55"
			//		baseURL: NSURL(string: "https://api.hermes.staging.public.stagebloc.co/v1")! // staging server
		)
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

	func testAuthenticationStateType() {
		// isAuthenticated
		XCTAssertFalse(AuthenticationState.unauthenticated.isAuthenticated)
		XCTAssertTrue(AuthenticationState.authenticated(token: "", user: nil).isAuthenticated)
		
		// token
		XCTAssertNil(AuthenticationState.unauthenticated.token)
		XCTAssertNotNil(AuthenticationState.authenticated(token: "", user: nil).token)
		
		// user
		XCTAssertNil(AuthenticationState.authenticated(token: "", user: nil).user)
	}
	
	func testClientDeauthentication() {
		XCTAssertFalse(client.authenticationStateContainer.state.isAuthenticated)
		client.authenticationStateContainer.state = .authenticated(token: "valid_token", user: nil)
		XCTAssertTrue(client.authenticationStateContainer.state.isAuthenticated)
		client.deauthenticate()
		XCTAssertFalse(client.authenticationStateContainer.state.isAuthenticated)
	}
	
	func testErrorInfoEquality() {
		XCTAssertEqual(testErrorInfo, testErrorInfo)
		XCTAssertNotEqual(testErrorInfo, API.ErrorInfo(
			type: testErrorInfo.type,
			descriptiveText: "_",
			devNotes: testErrorInfo.devNotes)
		)
	}
	
	func testErrorEquality() {
		let nsError = NSError(
			domain: "com.fullscreendirect.test_error_domain",
			code: 1,
			userInfo: nil
		)
		let decodeError = DecodeError.Custom("test error")
		
		XCTAssertEqual(API.Error.multipartDataEncoding, API.Error.multipartDataEncoding)
		XCTAssertEqual(API.Error.underlying(nsError), API.Error.underlying(nsError))
		XCTAssertEqual(API.Error.jsonDecoding(decodeError), API.Error.jsonDecoding(decodeError))
		XCTAssertEqual(API.Error.api(testErrorInfo), API.Error.api(testErrorInfo))
		XCTAssertNotEqual(API.Error.multipartDataEncoding, API.Error.underlying(nsError))
	}
	
	private func jsonForFile(named name: String) -> JSON {
		let thisBundle = NSBundle(forClass: self.dynamicType)
		let path = thisBundle.pathForResource(name, ofType: "json")!
		let data = NSData(contentsOfFile: path)
		let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
		return JSON(json)
	}
	
	func testAccountDecoding() {
		switch Account.decode(jsonForFile(named: "Account")) {
		case .Failure(let error):
			XCTFail(error.description)
		case .Success(_):
			()
		}
	}
	
	func testAccountPhotoDecoding() {
		switch AccountPhoto.decode(jsonForFile(named: "AccountPhoto")) {
		case .Failure(let error):
			XCTFail(error.description)
		case .Success(_):
			()
		}
	}
	
	func testBlogDecoding() {
		switch Blog.decode(jsonForFile(named: "Blog")) {
		case .Failure(let error):
			XCTFail(error.description)
		case .Success(_):
			()
		}
	}

	func testCartDecoding() {
		switch Cart.decode(jsonForFile(named: "Cart")) {
		case .Failure(let error):
			XCTFail(error.description)
		case .Success(_):
			()
		}
	}
	
	func testShippingRateSetDecoding() {
		switch Shipping.RateSet.decode(jsonForFile(named: "ShippingRateSet")) {
		case .Failure(let error):
			XCTFail(error.description)
		case .Success(_):
			()
		}
	}

}
