//
//  RGBComponents.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/21/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct RGBComponents: Codable {
	
	public var red: UInt8
	public var green: UInt8
	public var blue: UInt8
	
	public init(from decoder: Decoder) throws {
		let value = try decoder.singleValueContainer().decode(String.self)
		let rgb = value.components(separatedBy: ",")
					.map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
					.flatMap { UInt8($0, radix: 10) }
		guard rgb.count == 3 else {
			throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "RGB colors need three components"))
		}
		red = rgb[0]
		green = rgb[1]
		blue = rgb[2]
	}
	
	#if os(iOS)
	public var UIColor: UIKit.UIColor {
		return .init(red: CGFloat(red) / 255,
		             green: CGFloat(green) / 255,
		             blue: CGFloat(blue) / 255,
		             alpha: 1)
	}
	#elseif os(OSX)
	public var NSColor: AppKit.NSColor {
		return .init(red: CGFloat(red) / 255,
		             green: CGFloat(green) / 255,
		             blue: CGFloat(blue) / 255,
		             alpha: 1)
	}
	#endif
	
}
