//
//  FormData.swift
//  CocoaBloc
//
//  Created by David Warner on 3/25/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Foundation

public struct FormDataPart {
	
	public let title: String
	public let dataType: DataType
	
	public enum DataType {
		case Data(NSData)
		case File(NSURL)
	}
	
	public init(title: String,
	            dataType: DataType) {
		self.title = title
		self.dataType = dataType
	}
}
