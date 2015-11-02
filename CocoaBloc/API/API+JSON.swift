//
//  API+JSON.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public protocol JSONDecodable {
    var modelType: MTLModel.Type { get }
}

extension API: JSONDecodable {
    public var modelType: MTLModel.Type {
        switch self {
        case .GetAccount:
            return SBAccount.self
            
        default:
            return SBObject.self
        }
    }
}