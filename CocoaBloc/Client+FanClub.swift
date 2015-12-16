//
//  Client+FanClub.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/16/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

extension Client {
    
    public func getFanClubDashboard(accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBFanClubDashboard> {
        return request(
            path: "account\(accountID)/fanclub/dashboard",
            method: .GET,
            expand: expansions
        )
    }
    
    public func createFanClub(accountID: Int, title: String, description: String, tierInfo: [String:AnyObject], expansions: [ExpandableValue] = []) -> Request<SBFanClub> {
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
    
    public enum FanClubType: String {
        case Featured   = "featured"
        case Recent     = "recent"
        case Following  = "following"
    }
    public func getFanClubs(accountID: Int, type: FanClubType, expansions: [ExpandableValue] = []) -> Request<[SBFanClub]> {
        return request(
            path: "account/\(accountID)/fanclubs/\(type.rawValue)",
            method: .GET,
            expand: expansions
        )
    }
    
//    public func getFanClubFans(accountID: Int) -> Request<[]
    
    public func getContentFromFollowedFanClubs(expansions: [ExpandableValue] = []) -> Request<[SBContent]> {
        return request(
            path: "account/fanclubs/following/content",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getFanClub(accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBFanClub> {
        return request(
            path: "account/\(accountID)/fanclub",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getFanClubContent(accountID: Int, expansions: [ExpandableValue] = []) -> Request<[SBContent]> {
        return request(
            path: "account/\(accountID)/fanclub/content",
            method: .GET,
            expand: expansions
        )
    }
}