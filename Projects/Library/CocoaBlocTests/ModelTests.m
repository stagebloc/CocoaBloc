//
//  ModelTests.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "SBObject.h"

SpecBegin(Models)

describe(@"Base Object", ^{
    NSError *err;
    NSDictionary *JSON = @{@"id" : @(5)};
    SBObject *obj = [MTLJSONAdapter modelOfClass:[SBObject class]
                              fromJSONDictionary:JSON
                                           error:&err];
    
    it(@"should deserialize", ^{
    	expect(err).to.beNil();
        expect(obj).toNot.beNil();
    });
    
    it(@"should have transformed to proper types", ^{
    	expect(obj.identifier).to.beKindOf(NSNumber.class);
    });
    
    it(@"should reserialize identically", ^{
    	NSDictionary *newJSON = [MTLJSONAdapter JSONDictionaryFromModel:obj];
        expect(newJSON).toNot.beNil();
        expect(newJSON).to.equal(JSON);
    });
});

SpecEnd