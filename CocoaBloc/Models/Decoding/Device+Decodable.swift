//
//  Device+Argo.Decodable.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-03-07.
//  Copyright © 2017 StageBloc. All rights reserved.
//

import Argo
import Runes
import Curry

extension Device: Argo.Decodable {
	
	public static func decode(_ json: JSON) -> Decoded<Device> {
		return curry(Device.init)
			<^> json <| "device_identifier"
			<*> json <| "label"
	}
	
}
