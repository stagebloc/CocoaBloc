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
import ReactiveMoya

class ProviderTests: XCTestCase {
    
    let provider = CocoaBlocProvider()
    
    override func setUp() {
        super.setUp()
        
        CocoaBlocProvider.ClientID = ".."
        CocoaBlocProvider.ClientSecret = ".."
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
                accountSignal.observeFailed { error in
                    if let response = error.userInfo["data"] as? MoyaResponse {
                        print(NSString(data: response.data, encoding: 4))
                    }
                }
            }
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
    
}
