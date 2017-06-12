//
//  ExpandableTests.swift
//  CocoaBloc
//
//  Created by John Heaton on 8/1/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

@testable import CocoaBloc
import Argo
import XCTest

class ExpandableTests: XCTestCase {
	
	static let identifier = 350
	
	struct TestIdentifiable: Identifiable, Argo.Decodable {
		var identifier: Int
		
		static func decode(_ json: JSON) -> Decoded<TestIdentifiable> {
			return TestIdentifiable.init <^> json <| "identifier"
		}
	}
	
	let unexpanded = Expandable<TestIdentifiable>.unexpanded(identifier: ExpandableTests.identifier)
	let expanded = Expandable<TestIdentifiable>.expanded(TestIdentifiable(identifier: ExpandableTests.identifier))
	
	func testValueProperty() {
		XCTAssertNil(unexpanded.value)
		XCTAssertNotNil(expanded.value)
		XCTAssertEqual(expanded.value?.identifier, .some(ExpandableTests.identifier))
	}
	
	func testIdentifierProperty() {
		XCTAssertEqual(unexpanded.identifier, ExpandableTests.identifier)
		XCTAssertEqual(expanded.identifier, ExpandableTests.identifier)
	}
	
	func testDecoding() {
		let numberDecoded = Expandable<TestIdentifiable>.decode(JSON(5))
		let stringDecoded = Expandable<TestIdentifiable>.decode(JSON("Potato"))
		let jsonDecoded = Expandable<TestIdentifiable>.decode(JSON(["identifier":ExpandableTests.identifier]))
		
		switch numberDecoded {
		case .success(let expandable):
			guard case .unexpanded = expandable else {
				XCTFail()
				break
			}
		case .failure(let decodeError):
			XCTFail(decodeError.description)
		}
//
		switch stringDecoded {
		case .success:
			XCTFail()
		case .failure:
			break
		}
		
		switch jsonDecoded {
		case .success(let expandable):
			guard case .expanded(let value) = expandable else {
				XCTFail()
				break
			}
			XCTAssertEqual(value.identifier, ExpandableTests.identifier)
		case .failure(let decodeError):
			XCTFail(decodeError.description)
		}
	}
}
