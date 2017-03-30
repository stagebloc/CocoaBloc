//
//  API+Device.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-03-07.
//  Copyright © 2017 StageBloc. All rights reserved.
//

extension API {
	
	public static func getDevice(withDeviceIdentifier deviceID: String, forAccount accountID: String) -> Endpoint<Device> {
		return Endpoint(path: "account/\(accountID)/device/\(deviceID)", method: .get)
	}
	
	public static func getDevices(forAccount accountID: String) -> Endpoint<[Device]> {
		return Endpoint(path: "account/\(accountID)/device", method: .get)
	}
	
	public static func saveDevice(forAccount accountID: String, device: Device) -> Endpoint<Device> {
		return Endpoint(path: "account/\(accountID)/device", method: .post,
		                parameters: [
							"device_identifier": device.identifier,
							"label": device.label
						]
		)
	}
}
