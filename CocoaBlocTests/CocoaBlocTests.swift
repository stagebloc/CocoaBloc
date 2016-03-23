//
//  CocoaBlocTests.swift
//  CocoaBlocTests
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import XCTest
@testable import CocoaBloc
import Alamofire

class CocoaBlocTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	func testObjectEquality() {
		let object = SBObject()
		object.kind = "special"
		object.identifier = 10
		let otherObject = SBObject()
		otherObject.kind = "special"
		otherObject.identifier = 10
		XCTAssertEqual(object, otherObject, "Two objects initialized with the same data should be equal")
		otherObject.kind = "not_special"
		XCTAssertNotEqual(object, otherObject,
		                  "Two objects initialized with different data shouldn't be equal")
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
}
