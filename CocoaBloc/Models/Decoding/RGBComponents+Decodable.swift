//
//  RGBComponents+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo

extension RGBComponents: Decodable {
	
	public static func decode(json: JSON) -> Decoded<RGBComponents> {
		guard case .String(let val) = json else {
			return .typeMismatch("String", actual: json)
		}
		
		let rgb = val.componentsSeparatedByString(",")
			.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
			.flatMap { UInt8($0, radix: 10) }
		guard rgb.count == 3 else {
			return .customError("RGB colors need three components")
		}
		
		return .Success(RGBComponents(red: rgb[0], green: rgb[1], blue: rgb[2]))
	}

}
