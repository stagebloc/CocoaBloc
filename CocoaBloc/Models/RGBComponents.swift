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

public struct RGBComponents {
	
	public var red: Float
	public var green: Float
	public var blue: Float
	
	#if os(iOS)
	public var UIColor: UIKit.UIColor {
		return .init(red: CGFloat(red / 255),
		             green: CGFloat(green / 255),
		             blue: CGFloat(blue / 255),
		             alpha: 1)
	}
	#elseif os(OSX)
	public var NSColor: AppKit.NSColor {
		return .init(red: CGFloat(red / 255),
		             green: CGFloat(green / 255),
		             blue: CGFloat(blue / 255),
		             alpha: 1)
	}
	#endif
	
}
