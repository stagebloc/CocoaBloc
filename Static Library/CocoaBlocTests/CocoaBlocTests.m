//
//  CocoaBlocTests.m
//  CocoaBlocTests
//
//  Created by John Heaton on 6/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "SBClient.h"

#define EXP_SHORTHAND

SpecBegin(APITests)

describe(@"Log In", ^{
	it(@"should error if given invalid credentials", ^{
    	EXP_expect([[SBClient new] logInWithUsername:nil password:nil]).to.raise(nil);
    });
});

SpecEnd