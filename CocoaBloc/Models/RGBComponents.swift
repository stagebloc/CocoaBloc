//
//  RGBComponents.swift
//  CocoaBloc
//
//  Created by John Heaton on 6/21/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct RGBComponents: Decodable {
	public var red, green, blue: Float
	
	public static func decode(json: JSON) -> Decoded<RGBComponents> {
		guard case .String(let val) = json else {
			return .typeMismatch("String", actual: json)
		}
		
		let rgb = val.componentsSeparatedByString(",").flatMap(Float.init)
		guard rgb.count == 3 else {
			return .customError("RGB colors need three components")
		}
		
		return .Success(RGBComponents(red: rgb[0], green: rgb[1], blue: rgb[2]))
	}
	
	#if os(iOS)
	public var UIColor: UIKit.UIColor {
		return UIKit.UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
	}
	#elseif os(OSX)
	public var NSColor: AppKit.NSColor {
		return AppKit.NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
	}
	#endif
}
