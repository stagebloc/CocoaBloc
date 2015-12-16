//
//  CocoaBlocTests.swift
//  CocoaBlocTests
//
//  Created by John Heaton on 11/21/15.
//  Copyright © 2015 StageBloc. All rights reserved.
//

import XCTest
@testable import CocoaBloc
import Alamofire

class CocoaBlocTests: XCTestCase {
    
    let client = Client(clientID: "de4346e640860eb3d6fd97e11e475d0d", clientSecret: "c2288f625407c5aff55e41d1fef1ed73")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthentication() {
        let e = expectationWithDescription("test")
        
        let request = client.logInWithUsername("hi@stagebloc.com", password: "starwars")
            .responseModel { (response: Response<SBUser, CocoaBloc.Error>) -> Void in
//                print(response)
            }
        
//        debugPrint(request.request)
        
        request.resume()
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
