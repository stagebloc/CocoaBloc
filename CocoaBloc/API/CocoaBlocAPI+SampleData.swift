//
//  CocoaBlocAPI+SampleData.swift
//  CocoaBloc
//
//  Created by David Warner on 10/7/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

extension CocoaBlocAPI {

    // Sample data declarations

    public var sampleData: NSData {
        switch self {

        case
        .loginWithAuthorizationCode:
            return "AAA".dataUsingEncoding(NSUTF8StringEncoding)!

        default:
            return "BBB".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}