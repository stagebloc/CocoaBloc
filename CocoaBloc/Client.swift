//
//  Client.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Result
import ReactiveCocoa

public class Client {
    
    public func request<E: EndpointType>(endpoint: E) -> Request<E> {
        return Request(request: endpoint.requestWithParameters([:]), endpoint: endpoint)
    }
}
