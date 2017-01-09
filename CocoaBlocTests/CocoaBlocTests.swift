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
	let requestTimeout: TimeInterval = 10
	
	// API client, fresh per test
	fileprivate(set) var client: Client<CallbackAuthenticationStateContainer>!

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
			"b": 1 as Optional<AnyObject>,
			"c": "test" as Optional<AnyObject>,
			"d": nil
		]
		let filtered = value.filterEntriesWithNilValues()
		
		XCTAssertNil(filtered.index(forKey: "a"))
		XCTAssertNil(filtered.index(forKey: "d"))
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
		let decodeError = DecodeError.custom("test error")
		
		XCTAssertEqual(API.Error.multipartDataEncoding, API.Error.multipartDataEncoding)
		XCTAssertEqual(API.Error.underlying(nsError), API.Error.underlying(nsError))
		XCTAssertEqual(API.Error.jsonDecoding(decodeError), API.Error.jsonDecoding(decodeError))
		XCTAssertEqual(API.Error.api(testErrorInfo), API.Error.api(testErrorInfo))
		XCTAssertNotEqual(API.Error.multipartDataEncoding, API.Error.underlying(nsError))
	}
	
	fileprivate func jsonForFile(named name: String) -> JSON {
		let thisBundle = Bundle(for: type(of: self))
		let path = thisBundle.path(forResource: name, ofType: "json")!
		let data = try? Data(contentsOf: Foundation.URL(fileURLWithPath: path))
		let json = try! JSONSerialization.jsonObject(with: data!, options: [])
		return JSON(json)
	}
	
	func testAccountDecoding() {
		switch Account.decode(jsonForFile(named: "Account")) {
		case .failure(let error):
			XCTFail(error.description)
		case .success(_):
			()
		}
	}
	
	func testAccountPhotoDecoding() {
		switch AccountPhoto.decode(jsonForFile(named: "AccountPhoto")) {
		case .failure(let error):
			XCTFail(error.description)
		case .success(_):
			()
		}
	}
	
	func testBlogDecoding() {
		switch Blog.decode(jsonForFile(named: "Blog")) {
		case .failure(let error):
			XCTFail(error.description)
		case .success(_):
			()
		}
	}

	func testCartDecoding() {
		switch Cart.decode(jsonForFile(named: "Cart")) {
		case .failure(let error):
			XCTFail(error.description)
		case .success(let cart):
			XCTAssertNotNil(cart.shippingAddress)
			XCTAssertNotNil(cart.shippingRates)
			XCTAssert(cart.items.count > 0)
		}
	}
	
	func testShippingRateSetDecoding() {
		switch Shipping.RateSet.decode(jsonForFile(named: "ShippingRateSet")) {
		case .failure(let error):
			XCTFail(error.description)
		case .success(_):
			()
		}
	}

}
