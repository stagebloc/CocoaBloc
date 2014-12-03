//
//  APITests.m
//  CocoaBlocTests
//
//  Created by John Heaton on 7/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "SBClient.h"
#import "SBClient+Auth.h"
#import "SBClient+User.h"
#import "SBClient+FanClub.h"
#import "SBClient+Audio.h"
#import "SBClient+Store.h"
#import "SBClient+Account.h"
#import "SBAudioUpload.h"

#import "CocoaBloc.h"

#define MAC_UPLOADER_TEMP_CID @"86610122f4d3cd23dff0a1448903947d"
#define MAC_UPLOADER_TEMP_CSE @"828c5543138fa5ad4ec360e08b66d1d4"

#define TEST_SB_CID	@"hey"
#define TEST_SB_CSE @"there"

#if !defined(TARGET_IPHONE_SIMULATOR)
#error For async magic to work, we must test on the simulator only!
#endif

SpecBegin(TestServer)

describe(@"Local Dev Server", ^{
    it(@"should be running", ^{
        
        AFHTTPRequestOperation *op =
        [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stagebloc.dev"]]];
        op.securityPolicy.allowInvalidCertificates = YES;
        
        waitUntil(^(DoneCallback done) {
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                expect(@(operation.response.statusCode)).to.equal(@(200));
                done();
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                expect(error).to.beNil();
                done();
            }];
            
            [op start];
        });
    });
});

SpecEnd

SpecBegin(API)

describe(@"Client", ^{
    __block SBClient *client;
    __block NSString *testProjectDirectory;
    beforeAll(^{
		expect(^{ client = SBClient.new; }).to.raiseAny();
		
        [SBClient setClientID:TEST_SB_CID clientSecret:TEST_SB_CSE redirectURI:@""];
		client = SBClient.new;
		
		testProjectDirectory = @(TEST_PROJ_DIR);
        expect(testProjectDirectory).toNot.beNil();
    });
    
	it(@"should not accept nil log in credentials", ^{
        expect(^{ [client logInWithUsername:@"username" password:nil];	}).to.raiseAny();
        expect(^{ [client logInWithUsername:nil password:@"password"]; 	}).to.raiseAny();
    	expect(^{ [client logInWithUsername:nil password:nil]; 			}).to.raiseAny();
    });
	
    it(@"should log in with the test account", ^{
		__block SBUser *_nextUser;
        
        waitUntil(^(DoneCallback done) {
            [[client logInWithUsername:@"hi@stagebloc.com" password:@"starwars"]
             subscribeNext:^(SBUser *user) {
                 expect((_nextUser = user)).to.beKindOf([SBUser class]);
             }
             error:^(NSError *error) {
                 expect(error).to.beNil();
                 done();
             }
             completed:^{
                 expect(client.authenticated).to.equal(@(YES));
                 expect(client.token).notTo.beNil();
                 expect(client.authenticatedUser).to.equal(_nextUser);
                 
                 for (id account in client.authenticatedUser.adminAccounts) {
                     expect(account).to.beKindOf([SBAccount class]);
                 }
                 
                 done();
             }];
        });
    });
    
    it(@"should... get me <3", ^{
        waitUntil(^(DoneCallback done) {
            [[client getAuthenticatedUser]
             subscribeNext:^(id user) {
                 expect(user).to.beKindOf([SBUser class]);
             }
             error:^(NSError *error) {
                 expect(error).to.beNil();
                 done();
             }
             completed:^{
                 expect(client.authenticatedUser).toNot.beNil();
                 for (id account in client.authenticatedUser.adminAccounts) {
                     expect(account).to.beKindOf([SBAccount class]);
                 }
                 
                 done();
             }];
        });
    });
    
    __block SBAudioUpload *audioUpload;
    it(@"should upload audio data", ^{
    	NSData *audioSample = [NSData dataWithContentsOfFile:[testProjectDirectory stringByAppendingPathComponent:@"sample.m4a"]];
        expect(@(audioSample.length)).to.beGreaterThan(@(0));
        
        RACSignal *progress,
        *upload = [client uploadAudioData:audioSample
                                withTitle:@"Test Upload"
                                 fileName:@"sample.m4a"
                          		toAccount:(SBAccount *)client.authenticatedUser.adminAccounts.firstObject
                           progressSignal:&progress];
        
        [progress subscribeNext:^(NSNumber *progress) {
            NSLog(@"%@", progress);
            
        	expect(progress).to.beGreaterThanOrEqualTo(@(0));
            expect(progress).to.beLessThanOrEqualTo(@(100));
        }];
    
        waitUntil(^(DoneCallback done) {
            [upload subscribeNext:^(SBAudioUpload *upload) {
                audioUpload = upload;
                expect(upload).toNot.beNil();
                done();
            } error:^(NSError *error) {
                expect(error).to.beNil();
                done();
            } completed:^{
                done();
            }];
        });
    });
    
    it(@"should get an audio track by id", ^{
        waitUntil(^(DoneCallback done) {
            [[client getAudioTrackWithID:audioUpload.identifier
                              forAccount:client.authenticatedUser.adminAccounts.firstObject]
             subscribeNext:^(SBAudioUpload *upload) {
                 done();
             } error:^(NSError *error) {
                 expect(error).to.beNil();
                 done();
             } completed:^{
                 done();
             }];
        });
    });
    
    it(@"should get an account's fan club info", ^{
        waitUntil(^(DoneCallback done) {
            [[client getContentFromFanClubForAccount:client.authenticatedUser.adminAccounts.firstObject
                                          parameters:@{SBAPIMethodParameterResultOffset: @(2),
                                                       SBAPIMethodParameterResultLimit : @(1)}]
             subscribeNext:^(NSArray *contentArray) {
                 
             } error:^(NSError *error) {
                 expect(error).to.beNil();
                 done();
             } completed:^{
                 done();
             }];
        });
    });
    
    it(@"should get an account's fan club content stream", ^{
        waitUntil(^(DoneCallback done) {
            [[client getRecentFanClubContentWithParameters:@{SBAPIMethodParameterResultLimit: @(3),
                                                             SBAPIMethodParameterResultLimit: @(1)}]
                 subscribeNext:^(id x) {
                     
                 } error:^(NSError *error) {
                     expect(error).to.beNil();
                     done();
                 } completed:^{
                     done();
                 }];
        });
    });
    
//		
//	it(@"should be able to create a fan club", ^AsyncBlock {
//		done();
//	});
	
	it(@"should get a user by id", ^{
        waitUntil(^(DoneCallback done) {
            [[client getUserWithID:client.authenticatedUser.identifier]
                 subscribeNext:^(id user) {
                     expect(user).to.beKindOf([SBUser class]);
                 }
                 error:^(NSError *error) {
                     expect(error).to.beNil();
                     done();
                 }
                 completed:^{
                     done();
                 }];
        });
	});
    
    it(@"should get an account by id", ^{
       waitUntil(^(DoneCallback done) {
           [[client getAccountWithID:[(SBAccount *)client.authenticatedUser.adminAccounts.firstObject identifier]]
            subscribeNext:^(SBAccount *account) {
                expect(account).toNot.beNil();
                expect(account).to.beKindOf([SBAccount class]);
                done();
            } error:^(NSError *error) {
                expect(error).to.beNil();
                done();
            }];
       });
    });
    
    it(@"should update account info", ^{
        waitUntil(^(DoneCallback done) {
            [[client updateAccount:(SBAccount *)client.authenticatedUser.adminAccounts.firstObject name:@"testuser" description:@"test desc" stageBlocURL:[NSString stringWithFormat:@"testurl-%f", [[NSDate date] timeIntervalSince1970]]]
                 subscribeNext:^(SBAccount *account) {
                    expect(account).toNot.beNil();
                    expect(account).to.beKindOf([SBAccount class]);
                } error:^(NSError *error) {
                    expect(error).to.beNil();
                    done();
                } completed:^{
                    done();
                }];
        });
    });
    
//    it(@"should get an account's activity stream", ^{
//        waitUntil(^(DoneCallback done) {
//            [[client getActivityStreamForAccount:(SBAccount *)client.authenticatedUser.adminAccounts.firstObject]
//             	subscribeNext:^(NSArray *x) {
//                    expect(x.firstObject).to.beKindOf([SBStoreItem class]);
//                } error:^(NSError *error) {
//                    expect(error).to.beNil();
//                    done();
//                } completed:^{
//                    done();
//                }];
//        });
//    });
    
    it(@"should get store items for an account", ^{
        waitUntil(^(DoneCallback done) {
            [[client getStoreItemsForAccount:client.authenticatedUser.adminAccounts.firstObject parameters:@{SBAPIMethodParameterResultLimit:@5}]
                subscribeNext:^(NSArray *storeItems) {
                    expect(storeItems.firstObject).to.beKindOf([SBStoreItem class]);
                } error:^(NSError *error) {
                    expect(error).to.beNil();
                    done();
                } completed:^{
                    done();
                }];
        });
    });
});

SpecEnd