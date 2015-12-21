//
//  Endpoint+FanClub.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension Endpoint {
    
    public func getFanClubDashboard(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBFanClubDashboard> {
        return request(
            path: "account\(accountID)/fanclub/dashboard",
            method: .GET,
            expand: expansions
        )
    }
    
    public func createFanClub(accountID: Int, title: String, description: String, tierInfo: [String:AnyObject], expansions: [ExpandableValue] = []) -> Endpoint<SBFanClub> {
        return request(
            path: "account/\(accountID)/fanclub/",
            method: .POST,
            expand: expansions,
            parameters: [
                "title"         : title,
                "description"   : description,
                "tier_info"     : tierInfo
            ]
        )
    }
    
    public func getFanClubs(accountID: Int, type: FanClubType, expansions: [ExpandableValue] = []) -> Endpoint<[SBFanClub]> {
        return request(
            path: "account/\(accountID)/fanclubs/\(type.rawValue)",
            method: .GET,
            expand: expansions
        )
    }
    
    //    public func getFanClubFans(accountID: Int) -> Request<[]
    
    public func getContentFromFollowedFanClubs(expansions: [ExpandableValue] = []) -> Endpoint<[SBContent]> {
        return request(
            path: "account/fanclubs/following/content",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getFanClub(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBFanClub> {
        return request(
            path: "account/\(accountID)/fanclub",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getFanClubContent(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<[SBContent]> {
        return request(
            path: "account/\(accountID)/fanclub/content",
            method: .GET,
            expand: expansions
        )
    }
}
