//
//  RGBComponentsTests.swift
//  CocoaBloc
//
//  Created by John Heaton on 8/1/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

@testable import CocoaBloc
import XCTest
import Argo

class RGBComponentsTests: XCTestCase {
	
	func testRGBStringDecoding() {
		let red: UInt8 = 50, green: UInt8 = 100, blue: UInt8 = 150
		let components = RGBComponents.decode(JSON.String("\(red), \(green), \(blue)"))
		switch components {
		case .Success(let components):
			XCTAssertEqual(red, components.red)
			XCTAssertEqual(green, components.green)
			XCTAssertEqual(blue, components.blue)
			
			let color = components.UIColor
			var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
			color.getRed(&r, green: &g, blue: &b, alpha: nil)
			XCTAssertEqual(CGFloat(red) / 255, r)
			XCTAssertEqual(CGFloat(green) / 255, g)
			XCTAssertEqual(CGFloat(blue) / 255, b)
		case .Failure(let decodeError):
			XCTFail(decodeError.description)
		}
		
		let badComponents = RGBComponents.decode(JSON.String("1, 2"))
		switch badComponents {
		case .Success:
			XCTFail()
		case .Failure:
			()
		}
	}
	
	func testWrongTypeDecoding() {
		guard case .Failure = RGBComponents.decode(JSON.Null) else {
			XCTFail()
			return
		}
		guard case .Failure = RGBComponents.decode(JSON.Number(5)) else {
			XCTFail()
			return
		}
		guard case .Failure = RGBComponents.decode(JSON.Array([])) else {
			XCTFail()
			return
		}
		guard case .Failure = RGBComponents.decode(JSON.Object([:])) else {
			XCTFail()
			return
		}
		guard case .Failure = RGBComponents.decode(JSON.Bool(true)) else {
			XCTFail()
			return
		}
	}
}