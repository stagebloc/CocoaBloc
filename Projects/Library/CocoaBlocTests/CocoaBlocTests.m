//
//  CocoaBlocTests.m
//  CocoaBlocTests
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "SBClient.h"

#define MAC_UPLOADER_TEMP_CID @"86610122f4d3cd23dff0a1448903947d"
#define MAC_UPLOADER_TEMP_CSE @"828c5543138fa5ad4ec360e08b66d1d4"

SpecBegin(API)

describe(@"Client", ^{
    __block SBClient *client;
    beforeAll(^{
        client = SBClient.new;
        [SBClient setClientID:MAC_UPLOADER_TEMP_CID clientSecret:MAC_UPLOADER_TEMP_CSE];
    });
    
	it(@"should not accept nil log in credentials", ^{
        expect(^{ [client logInWithUsername:@"username" password:nil];	}).to.raiseAny();
        expect(^{ [client logInWithUsername:nil password:@"password"]; 	}).to.raiseAny();
    	expect(^{ [client logInWithUsername:nil password:nil]; 			}).to.raiseAny();
    });
    
    it(@"should log in with the test account", ^AsyncBlock {
    	[[client logInWithUsername:@"hi@stagebloc.com" password:@"starwars"]
        	subscribeError:^(NSError *error) {
        		expect(error).to.beNil();
            	done();
            }
         	completed:^{
                expect(client.authenticated).to.equal(YES);
                expect(client.token).notTo.beNil();
           	 	done();
        	}];
    });
    
    it(@"should... get me <3", ^AsyncBlock {
    	[[client getMe] subscribeNext:^(id user) {
            expect(user).to.beKindOf([SBUser class]);
        } error:^(NSError *error) {
            expect(error).to.beNil();
            done();
        } completed:^{
            done();
        }];
    });
});

SpecEnd