//
//  ProviderTests.swift
//  CocoaBloc
//
//  Created by John Heaton on 10/26/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import XCTest
import CocoaBloc
import ReactiveCocoa

class ProviderTests: XCTestCase {
    
    let provider = CocoaBlocProvider()
    
    override func setUp() {
        super.setUp()
        
        CocoaBlocProvider.ClientID = "de4346e640860eb3d6fd97e11e475d0d"
        CocoaBlocProvider.ClientSecret = "c2288f625407c5aff55e41d1fef1ed73"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    func testGetAccounts() {
        let expectation = self.expectationWithDescription("get accounts works")
        
        provider
            .requestJSON(.GetAccount(accountID: 7))
            .startWithSignal { (accountSignal: Signal<SBAccount, NSError>, disposable) in
                accountSignal.observeNext { account in
                    print(account)
                    
                    expectation.fulfill()
                }
            }
        
        self.waitForExpectationsWithTimeout(15, handler: nil)
    }
    
}
