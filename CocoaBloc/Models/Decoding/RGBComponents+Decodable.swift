//
//  RGBComponents+Decodable.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/30/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo

extension RGBComponents: Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<RGBComponents> {
		guard case .string(let val) = json else {
			return .typeMismatch(expected: "String", actual: json)
		}
		
		let rgb = val.components(separatedBy: ",")
			.map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
			.flatMap { UInt8($0, radix: 10) }
		guard rgb.count == 3 else {
			return .customError("RGB colors need three components")
		}
		
		return .success(RGBComponents(red: rgb[0], green: rgb[1], blue: rgb[2]))
	}

}
