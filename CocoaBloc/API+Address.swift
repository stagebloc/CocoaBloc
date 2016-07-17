//
//  API+Address.swift
//  CocoaBloc
//
//  Created by John Heaton on 7/16/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Argo
import Foundation
import Alamofire

extension API {

	public static func getAddress(withID addressID: Int) -> Endpoint<Address> {
		return Endpoint(path: "users/me/addresses/\(addressID)", method: .GET)
	}
	
//	public static func 
}