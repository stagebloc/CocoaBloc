//
//  FormData.swift
//  CocoaBloc
//
//  Created by David Warner on 3/25/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Foundation

public struct FormDataPart {
	
	public enum DataSource {
		case data(Data)
		case file(Foundation.URL)
	}
	
	public let title: String
	public let source: DataSource
	
}
