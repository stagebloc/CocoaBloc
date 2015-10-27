//
//  SBClient.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/26/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

public class SBClient: NSObject {
    private let provider = CocoaBlocProvider()
    
    @objc(isAuthenticated) public dynamic var authenticated: Bool = false
    public dynamic var token: String?
    
    
}
