//
//  Endpoint+Store.swift
//  CocoaBloc
//
//  Created by David Warner on 12/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension Endpoint {
    
    public func getStoreDashboard(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBStoreDashboard> {
        return request(
            path: "account/\(accountID)/store/dashboard",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getOrders(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<[SBOrder]> {
        return request(
            path: "account/\(accountID)/store/orders",
            method: .GET,
            expand: expansions
        )
    }
    
    public func setOrderShipped(orderID: Int, accountID: Int, trackingNumber: String, carrier: String, expansions: [ExpandableValue] = []) -> Endpoint<SBOrder> {
        return request(
            path: "account/\(accountID)/store/orders/\(orderID)",
            method: .POST,
            expand: expansions,
            parameters: [
                "tracking_number": trackingNumber,
                "carrier": carrier
            ]
        )
    }
    
    public func getStoreItemsForAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<[SBStoreItem]> {
        return request(
            path: "account/\(accountID)/store/items",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getStoreItem(storeItemID: Int, accountID: Int, expansions: [ExpandableValue] = []) -> Endpoint<SBStoreItem> {
        return request(
            path: "account/\(accountID)/store/items/\(storeItemID)",
            method: .GET,
            expand: expansions
        )
    }
}
