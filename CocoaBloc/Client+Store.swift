//
//  Client+Store.swift
//  CocoaBloc
//
//  Created by John Heaton on 12/16/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

extension Client {
    
    public func getStoreDashboard(accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBStoreDashboard> {
        return request(
            path: "account/\(accountID)/store/dashboard",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getOrders(accountID: Int, expansions: [ExpandableValue] = []) -> Request<[SBOrder]> {
        return request(
            path: "account/\(accountID)/store/orders",
            method: .GET,
            expand: expansions
        )
    }
    
    public func setOrderShipped(orderID: Int, accountID: Int, trackingNumber: String, carrier: String, expansions: [ExpandableValue] = []) -> Request<SBOrder> {
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
    
    public func getStoreItemsForAccount(accountID: Int, expansions: [ExpandableValue] = []) -> Request<[SBStoreItem]> {
        return request(
            path: "account/\(accountID)/store/items",
            method: .GET,
            expand: expansions
        )
    }
    
    public func getStoreItem(storeItemID: Int, accountID: Int, expansions: [ExpandableValue] = []) -> Request<SBStoreItem> {
        return request(
            path: "account/\(accountID)/store/items/\(storeItemID)",
            method: .GET,
            expand: expansions
        )
    }
}