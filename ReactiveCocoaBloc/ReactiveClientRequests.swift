//
//  Request+SignalProducer.swift
//  ReactiveCocoaBloc
//
//  Created by John Heaton on 12/17/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Alamofire
import Argo
import ReactiveSwift

extension Client {
	
	public func request(
		_ endpoint: Endpoint<()>,
		expansions: [API.ExpandableValue] = [],
		cached: Bool = false,
		requestConfiguration: ((Alamofire.DataRequest) -> ())? = nil)
		-> SignalProducer<(), API.APIError> {
			return SignalProducer { observer, disposable in
				let request: Alamofire.DataRequest = self.request(endpoint, expansions: expansions, cached: cached)
				
				request.response { response in
					if let error = response.error {
						observer.send(error: error as! API.APIError)
						return
					}
					observer.send(value: ())
					observer.sendCompleted()
				}
			}
	}
	
	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		cached: Bool = false,
		requestConfiguration: ((Alamofire.DataRequest) -> ())? = nil)
		-> SignalProducer<Serialized, API.APIError> where Serialized.DecodedType == Serialized {
			return SignalProducer { observer, disposable in
				let request = self.request(endpoint, expansions: expansions, cached: cached) { response in
					switch response.result {
					case .success(let value):
						observer.send(value: value)
						observer.sendCompleted()
					case .failure(let error):
						observer.send(error: error as! API.APIError)
					}
				}
				requestConfiguration?(request)
				request.resume()
				disposable += request.cancel
			}
	}
	
	public func request<Serialized: Decodable>(
		_ endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		cached: Bool = false,
		requestConfiguration: ((Alamofire.DataRequest) -> ())? = nil)
		-> SignalProducer<[Serialized], API.APIError> where Serialized.DecodedType == Serialized {
			return SignalProducer { observer, disposable in
				let request = self.request(endpoint, expansions: expansions, cached: cached) { response in
					switch response.result {
					case .success(let value):
						observer.send(value: value)
						observer.sendCompleted()
					case .failure(let error):
						observer.send(error: error as! API.APIError)
					}
				}
				requestConfiguration?(request)
				request.resume()
				disposable += request.cancel
			}
	}
	
}

extension Client {
	
	public func upload<Serialized: Decodable>(
		_ endpoint: Endpoint<Serialized>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Alamofire.Request) -> ())? = nil)
		-> SignalProducer<Serialized, API.APIError> where Serialized.DecodedType == Serialized {
			return SignalProducer { observer, disposable in
				self.uploadModelSerialization(endpoint,
				expansions: expansions,
				requestConfiguration: requestConfiguration) { result in
					switch result {
					case .success(let value):
						observer.send(value: value)
						observer.sendCompleted()
					case .failure(let error):
						observer.send(error: error as! API.APIError)
					}
				}
			}
	}
	
	public func upload<Serialized: Decodable>(
		_ endpoint: Endpoint<[Serialized]>,
		expansions: [API.ExpandableValue] = [],
		requestConfiguration: ((Alamofire.Request) -> ())? = nil)
		-> SignalProducer<[Serialized], API.APIError> where Serialized.DecodedType == Serialized {
			return SignalProducer { observer, disposable in
				// swiftlint:disable line_length
				self.uploadArraySerialization(endpoint,
				expansions: expansions,
				requestConfiguration: requestConfiguration) { result in
					// swiftlint:enable line_length
					switch result {
					case .success(let value):
						observer.send(value: value)
						observer.sendCompleted()
					case .failure(let error):
						observer.send(error: error as! API.APIError)
					}
				}
			}
	}
	
}
