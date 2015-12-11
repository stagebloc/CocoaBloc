//
//  Request.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/24/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Mantle
import Alamofire

public struct MantleResponseSerializer<ModelType: MTLModel>: ResponseSerializerType {
    let keyPath: String = "data"
    
//    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Alamofire.Result<ModelType, CocoaBloc.Error> {
//        return { request, response, data, error in
//            let JSONSerializer = Alamofire.Request.JSONResponseSerializer()
//            return JSONSerializer.serializeResponse(request, response, data, error)
//                
////            }
//        }
////        switch  {
////            
////        }
//    }
}

public final class Request<ModelType: MTLModel> {
    
    /// The underlying request
    public let request: Alamofire.Request
    
    var expansions: [Expandable] = []

    private let modelResponseSerializer: MantleResponseSerializer<ModelType, CocoaBloc.Error>
    
    public init(request: Alamofire.Request) {
        self.request = request
    }
}

//public extension Request where ModelType: MTLModel {
//    public func responseModel(completion: Alamofire.Response<ModelType, CocoaBloc.Error> -> Void) {
//        request.responseJSON { response in
//            switch response.result {
//            case .Success(let value):
//                if
//                    let dict = value as? [String:AnyObject],
//                    let data = dict[self.keyPath] as? [NSObject:AnyObject] {
//                        do {
//                            if let model = try MTLJSONAdapter.modelOfClass(ModelType.self, fromJSONDictionary: data) as? ModelType {
//                                completion(Response(request: response.request, response: response.response, data: response.data, result: .Success(model)))
//                            } else {
//                                completion(Response(request: response.request, response: response.response, data: response.data, result: .Failure(Error.UnexpectedResponseType)))
//                            }
//                        }
//                        catch let error as NSError {
//                            completion(Response(request: response.request, response: response.response, data: response.data, result: .Failure(Error.JSONSerialization(error))))
//                        }
//                }
//            case .Failure(let error):
//                completion(Response(request: response.request, response: response.response, data: response.data, result: .Failure(Error.JSONSerialization(error))))
//            }
//        }
//        request.resume()
//    }
//}

//public extension Request where ModelType: SequenceType, ModelType.Generator.Element: MTLModel {
//    public func responseModels(completion: Alamofire.Response<ModelType, CocoaBloc.Error>) {
//        
//    }
//}