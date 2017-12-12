//
//  String+Extension.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-07-08.
//  Copyright © 2017 Fullscreen Direct. All rights reserved.
//

extension String {
	func addingPercentEncodingForURLQueryValue() -> String? {
		let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~@")
		
		return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
	}
}
