//
//  Request.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public final class Request<Model> {
    
    /// The underlying request
    public let request: Alamofire.Request
    
    /// The key path in the JSON response to look for the model at
    public let keyPath: String

    public init(request: Alamofire.Request, keyPath: String) {
        self.request = request
        self.keyPath = keyPath
    }
    
    public func resume() {
        request.resume()
    }
}

public extension Request where Model: MTLModel {
    public func responseModel(completionHandler: Alamofire.Response<Model, CocoaBloc.Error> -> Void) -> Self {
        request.response(responseSerializer: Alamofire.Request.MantleResponseSerializer(keyPath), completionHandler: completionHandler)
        return self
    }
}

public extension Request where Model: SequenceType, Model.Generator.Element: MTLModel {
    public func responseModels(completionHandler: Alamofire.Response<[Model.Generator.Element], CocoaBloc.Error> -> Void) -> Self {
        request.response(responseSerializer: Alamofire.Request.MantleResponseSerializer(keyPath), completionHandler: completionHandler)
        return self
    }
}