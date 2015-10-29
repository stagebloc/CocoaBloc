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
    
    var provider: CocoaBlocProvider!
    
    override func setUp() {
        super.setUp()
        
        CocoaBlocProvider.ClientID = "794d9d691157d5c0ba86942c264793ea"
        CocoaBlocProvider.ClientSecret = "1c901cde6186bd42eb6be8ff7f692ff1"
        
        provider = CocoaBlocProvider()
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
                    XCTAssert(account.isKindOfClass(SBAccount.self))
                    expectation.fulfill()
                }
                accountSignal.observeFailed { error in
                    XCTFail()
                }
        }
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
}
