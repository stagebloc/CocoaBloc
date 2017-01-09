//
//  NSData+MimeType.swift
//  CocoaBloc
//
//  Created by David Warner on 3/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Foundation

extension Data {
	
	internal func photoMime() -> String {
		var c = [UInt32](repeating: 0, count: 1)
		(self as NSData).getBytes(&c, length: 1)
		switch c[0] {
		case 0xFF:
			return "image/jpeg"
		case 0x89:
			return "image/png"
		case 0x47:
			return "image/gif"
		case 0x49, 0x4d:
			return "image/tiff"
		default :
			return ""
		}
	}
}
