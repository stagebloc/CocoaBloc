//
//  ModelSerializable.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/19/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle

/// Provides a way to verify the caller is using the hright specialization of 
/// a generic request function for a known model type
public protocol ModelSerializable {
    var modelType: MTLModel.Type? { get }
}