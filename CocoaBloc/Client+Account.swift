//
//  Client+Account.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/15/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

extension Client {
    
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
    
    public func createAccount(name: String, description: String, url: String, type: AccountType, color: AccountColor, expansions: [ExpandableValue] = []) -> Request<SBAccount> {
        return request(
            path: "account",
            method: .POST,
            expand: expansions,
            parameters: [
                "name"          : name,
                "description"   : description,
                "stagebloc_url" : url,
                "type"          : type.rawValue,
                "color"         : color.rawValue
            ]
        )
    }
    
//    public func getAccountsForUser(userID: Int, includeAdminAccounts: Bool = true, includeFollowingAccounts: Bool = true, expansions: [ExpandableValue] = []) -> Request<[SBAccount]> {
//        return request(
//            path: "accounts",
//            method: .GET,
//            expand: expansions
//        )
//    }
    
    public func followAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBAccount> {
        return request(
            path: "/account/\(accountID)/follow",
            method: .POST,
            expand: expansions
        )
    }
    
    public func unfollowAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBAccount> {
        return request(
            path: "/account/\(accountID)/follow",
            method: .POST,
            expand: expansions
        )
    }
    
    public func getAuthenticatedUserAccounts(expansions: [ExpandableValue] = []) -> Request<[SBAccount]> {
        return request(
            path: "accounts",
            method: .GET,
            expand: expansions
        )
    }
}