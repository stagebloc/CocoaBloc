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
	
	// API client, fresh per test
	private(set) var client: Client!

	// Test values
	let testErrorInfo = API.ErrorInfo(
		type: .InvalidData,
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
		XCTAssertFalse(AuthenticationState.Unauthenticated.isAuthenticated)
		XCTAssertTrue(AuthenticationState.Authenticated(token: "", user: nil).isAuthenticated)
		
		// token
		XCTAssertNil(AuthenticationState.Unauthenticated.token)
		XCTAssertNotNil(AuthenticationState.Authenticated(token: "", user: nil).token)
		
		// user
		XCTAssertNil(AuthenticationState.Authenticated(token: "", user: nil).user)
	}
	
	func testClientDeauthentication() {
		XCTAssertFalse(client.authenticationState.isAuthenticated)
		client.authenticationState = .Authenticated(token: "valid_token", user: nil)
		XCTAssertTrue(client.authenticationState.isAuthenticated)
		client.deauthenticate()
		XCTAssertFalse(client.authenticationState.isAuthenticated)
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
		
		XCTAssertEqual(API.Error.MultipartDataEncoding, API.Error.MultipartDataEncoding)
		XCTAssertEqual(API.Error.Underlying(nsError), API.Error.Underlying(nsError))
		XCTAssertEqual(API.Error.JSONDecoding(decodeError), API.Error.JSONDecoding(decodeError))
		XCTAssertEqual(API.Error.API(testErrorInfo), API.Error.API(testErrorInfo))
		XCTAssertNotEqual(API.Error.MultipartDataEncoding, API.Error.Underlying(nsError))
	}
	
	struct TestExpandableType: Decodable, Identifiable {
		var identifier: Int
		
		static func decode(json: JSON) -> Decoded<TestExpandableType> {
			return TestExpandableType.init <^> json <| "id"
		}
	}
	func testExpandableType() {
		let identifier = 5
		let value = TestExpandableType(identifier: identifier)
		let expanded = Expandable<TestExpandableType>.expanded(value)
		let unexpanded = Expandable<TestExpandableType>.unexpanded(identifier: identifier)
		
		XCTAssertEqual(expanded.identifier, unexpanded.identifier)
		
		XCTAssertNil(unexpanded.value)
		XCTAssertNotNil(expanded.value)
		XCTAssertEqual(expanded.value?.identifier, value.identifier)
	}
	
	func testExpandableArrayType() {
		let value = [1, 2, 3]
		let expanded = ExpandableArray<Int>.expanded(value)
		let unexpanded = ExpandableArray<Int>.unexpanded(count: value.count)
		
		XCTAssertEqual(expanded.count, unexpanded.count)
		
		XCTAssertNil(unexpanded.value)
		XCTAssertNotNil(expanded.value)
		XCTAssertEqual(expanded.value!, value)
	}

}
