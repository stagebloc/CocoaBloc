//
//  Endpoint+FanClub.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension StageBloc {
    
    public static func getFanClubDashboard(accountID: Int) -> Endpoint<SBFanClubDashboard> {
        return Endpoint(
            path: "account\(accountID)/fanclub/dashboard",
            method: .GET)
    }
    
    public static func createFanClub(accountID: Int, title: String, description: String, tierInfo: [String:AnyObject]) -> Endpoint<SBFanClub> {
        return Endpoint(
            path: "account/\(accountID)/fanclub/",
            method: .POST,
            parameters: [
                "title"         : title,
                "description"   : description,
                "tier_info"     : tierInfo
            ])
    }
    
    public static func getFanClubs(accountID: Int, type: FanClubType) -> Endpoint<[SBFanClub]> {
        return Endpoint(
            path: "account/\(accountID)/fanclubs/\(type.rawValue)",
            method: .GET)
    }
    
    public static func getContentFromFollowedFanClubs() -> Endpoint<[SBContent]> {
        return Endpoint(
            path: "account/fanclubs/following/content",
            method: .GET)
    }
    
    public static func getFanClub(accountID: Int) -> Endpoint<SBFanClub> {
        return Endpoint(
            path: "account/\(accountID)/fanclub",
            method: .GET)
    }
    
    public static func getFanClubContent(accountID: Int) -> Endpoint<[SBContent]> {
        return Endpoint(
            path: "account/\(accountID)/fanclub/content",
            method: .GET)
    }
}
