//
//  Device.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-03-07.
//  Copyright © 2017 StageBloc. All rights reserved.
//

public struct Device {
	public let identifier: String
	public let label: String
	
	public init(identifier: String, label: String) {
		self.identifier = identifier
		self.label = label
	}
}
