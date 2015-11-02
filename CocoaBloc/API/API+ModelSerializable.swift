//
//  API+ModelSerializable.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public protocol ModelSerializable {
    var modelType: SBObject.Type { get }
}

extension API: ModelSerializable {
    public var modelType: SBObject.Type {
        switch self {
        case .GetAccount:
            return SBAccount.self
        case
        .LogInWithUsername,
        .GetUser:
            return SBUser.self
            
        default:
            return SBObject.self
        }
    }
}