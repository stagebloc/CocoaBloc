//
//  Endpoint.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation
import Mantle
import Alamofire

public struct Endpoint<T> {
    
    private let manager: Alamofire.Manager
    private let baseURL = NSURL(string: "https://api.stagebloc.com/v1")!
    
    public var path : String
    public var method : Alamofire.Method
    public var expansions : [ExpandableValue]
    public var parameters : [String:AnyObject]

    
    public var request : Request<T>
    
}

public enum ExpandableValue: String {
    case Photo      = "photo"
    case Photos     = "photos"
    case Account    = "account"
    case User       = "user"
    case Tags       = "tags"
    case Audio      = "audio"
    case CreatedBy  = "created_by"
    case ModifiedBy = "modified_by"
    case Content    = "content"
}

public enum UserColor: String {
    case Blue   = "blue"
    case Teal   = "teal"
    case Green  = "green"
    case Pink   = "pink"
    case Red    = "red"
    case Purple = "purple"
}

public enum Gender: String {
    case Male       = "male"
    case Female     = "female"
    case Cupcake    = "cupcake"
}

public enum ContentTypeIdentifier: String {
    case Photo  = "photo"
    case Audio  = "audio"
    case Video  = "video"
    case Blog   = "blog"
    case Status = "status"
}

public enum AccountColor: String {
    case Blue       = "blue"
    case Purple     = "purple"
    case Red        = "red"
    case Orange     = "orange"
    case Grey       = "grey"
    case Green      = "green"
}

public enum AccountType: String {
    case Music              = "music"
    case FilmAndTV          = "film/tv"
    case Entertainment      = "entertainment"
    case Sports             = "sports"
    case Celebrity          = "celebrity"
    case Comedian           = "comedian"
    case RecordLabel        = "record label"
    case ManagementCompany  = "management company"
    case Personal           = "personal"
    case Developer          = "developer"
    case Photography        = "photography"
    case Cooking            = "food"
    case Business           = "business"
    case Organization       = "organization"
    case Other              = "other"
}

public enum FanClubType: String {
    case Featured   = "featured"
    case Recent     = "recent"
    case Following  = "following"
}
