//
//  Error.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public enum Error: ErrorType {
	case JSONSerialization(NSError)
	case UnexpectedResponseType
	case API(String)
	case Underlying(NSError)
}
