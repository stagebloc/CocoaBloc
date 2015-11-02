//
//  API+Expansion.swift
//  CocoaBloc
//
//  Created by John Heaton on 11/2/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import Foundation

public protocol Expandable {
    var expansionKey: String { get }
}

extension SBObject {
    public var expansionKey: String {
        return "kind"
    }
}
