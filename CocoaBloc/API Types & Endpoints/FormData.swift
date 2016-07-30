//
//  FormData.swift
//  CocoaBloc
//
//  Created by David Warner on 3/25/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Foundation

public struct FormDataPart {
	
	public enum DataType {
		case data(NSData)
		case file(NSURL)
	}
	
	public let title: String
	public let dataType: DataType
	
}
