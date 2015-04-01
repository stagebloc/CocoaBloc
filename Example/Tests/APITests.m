//
//  APITests.m
//  CocoaBloc
//
//  Created by John Heaton on 4/1/15.
//  Copyright (c) 2015 John Heaton. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CocoaBloc/CocoaBloc.h>

#define they it

SpecBegin(API)

describe(@"Constants", ^{
    they(@"should not be nil", ^{
        expect(CocoaBlocMissingClientIDSecretException).toNot.beNil();
        expect(SBAPIMethodParameterResultLimit).toNot.beNil();
        expect(SBAPIMethodParameterResultOffset).toNot.beNil();
        expect(SBAPIMethodParameterResultDirection).toNot.beNil();
        expect(SBAPIMethodParameterResultOrderBy).toNot.beNil();
        expect(SBAPIMethodParameterResultExpandedProperties).toNot.beNil();
        expect(SBAPIMethodParameterResultFilter).toNot.beNil();
        expect(SBAPIMethodParameterResultIncludeAdminAccounts).toNot.beNil();
        expect(SBAPIMethodParameterResultFanContent).toNot.beNil();
        expect(SBAPIMethodParameterResultFollowing).toNot.beNil();
        expect(SBAPIErrorResponseObjectKey).toNot.beNil();
        expect(SBCocoaBlocErrorDomain).toNot.beNil();
        expect(SBAPIMethodParameterFlagContentValueOffensive).toNot.beNil();
        expect(SBAPIMethodParameterFlagContentValuePrejudice).toNot.beNil();
        expect(SBAPIMethodParameterFlagContentValueCopyright).toNot.beNil();
        expect(SBAPIMethodParameterFlagContentValueDuplicate).toNot.beNil();
        expect(CocoaBlocMissingClientIDSecretException).toNot.beNil();
        expect(CocoaBlocMissingClientIDSecretException).toNot.beNil();
    });
});

describe(@"Client", ^{
    it(@"should raise on init if no clientID+clientSecret set", ^{
        expect(^{ return [SBClient new]; }).to.raise(CocoaBlocMissingClientIDSecretException);
    });
    
    it(@"should raise on init if empty clientID+clientSecret set", ^{
        [SBClient setClientID:@"" clientSecret:@"" redirectURI:@""];

        expect(^{ return [SBClient new]; }).to.raise(CocoaBlocMissingClientIDSecretException);
    });
    
    it(@"should init after clientID+clientSecret set", ^{
        [SBClient setClientID:@"A" clientSecret:@"B" redirectURI:@""];
        
        expect(^{ return [SBClient new]; }).notTo.raise(CocoaBlocMissingClientIDSecretException);
    });
});

SpecEnd