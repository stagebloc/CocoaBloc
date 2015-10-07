//
//  CocoaBlocProvider.swift
//  CocoaBloc
//
//  Created by David Warner on 10/6/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveMoya

class CocoaBlocProvider<T where T: MoyaTarget>: ReactiveCocoaMoyaProvider<T> {

        init(endpointClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping,
            endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEndpointResolution,
            stubBehavior: MoyaStubbedBehavior = MoyaProvider.NoStubbingBehavior,
            networkActivityClosure: Moya.NetworkActivityClosure? = nil) {

            super.init(endpointClosure: endpointClosure,
                endpointResolver: endpointResolver,
                stubBehavior: stubBehavior,
                networkActivityClosure: networkActivityClosure)
        }
}
