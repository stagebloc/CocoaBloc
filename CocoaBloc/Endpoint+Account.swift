//
//  Endpoint+Account.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension Endpoint {
    
    public func createAccount(name: String, description: String, url: String, type: AccountType, color: AccountColor, expansions: [ExpandableValue] = []) -> Endpoint<SBAccount> {
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
    
    public func followAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBAccount> {
        return request(
            path: "/account/\(accountID)/follow",
            method: .POST,
            expand: expansions
        )
    }
    
    public func unfollowAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBAccount> {
        return request(
            path: "/account/\(accountID)/follow",
            method: .POST,
            expand: expansions
        )
    }
    
    public func getAuthenticatedUserAccounts(expansions: [ExpandableValue] = []) -> Endpoint<[SBAccount]> {
        return request(
            path: "accounts",
            method: .GET,
            expand: expansions
        )
    }
}
