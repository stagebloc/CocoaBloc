//
//  Device.swift
//  CocoaBloc
//
//  Created by Billy Lavoie on 2017-03-07.
//  Copyright © 2017 StageBloc. All rights reserved.
//

public struct Device: Codable {
	public let identifier: String
	public let label: String
	
	public init(identifier: String, label: String) {
		self.identifier = identifier
		self.label = label
	}
	
	private enum CodingKeys: String, CodingKey {
		case identifier = "device_identifier", label
	}
}

extension Client {
	
	public func getDevice(withDeviceIdentifier deviceID: String, forAccount accountID: String, completionHandler: @escaping (Device?, Error?) -> Void) {
		get(withEndPoint: "account/\(accountID)/device/\(deviceID)", completionHandler: completionHandler)
	}
	
	public func getDevices(forAccount accountID: String, completionHandler: @escaping ([Device]?, Error?) -> Void) {
		get(withEndPoint: "account/\(accountID)/device", completionHandler: completionHandler)
	}
	
	public func saveDevice(forAccount accountID: String, device: Device, completionHandler: @escaping (Device?, Error?) -> Void) {
		do {
			let encoder = JSONEncoder()
			let deviceJSON = try encoder.encode(device)
			post(withEndPoint: "account/\(accountID)/device", postJSON: deviceJSON, completionHandler: completionHandler)
		} catch {
			completionHandler(nil, error)
		}
	}
}
