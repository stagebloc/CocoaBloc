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
#import "SBAudioUpload.h"

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


describe(@"Audio upload", ^{
    NSError *err;
    NSDictionary *JSON = @{
        @"account" 			: @19,
        @"comment_count" 	: @0,
        @"created" 			: @"2014-07-29 16:35:55",
        @"edit_url" 		: @"https://stagebloc.dev/demo17/admin/audio/edit/781",
        @"exclusive" 		: @0,
        @"id" 				: @781,
        @"in_moderation" 	: @0,
        @"like_count" 		: @0,
        @"modified" 		: @"2014-07-29 16:35:57",
        @"short_url" 		: @"http://stgb.dev/a/et",
        @"sticky" 			: @0,
        @"title" 			: @"Test Upload",
        @"user"				: @0,
        @"user_has_liked" 	: @0
    };
    SBAudioUpload *obj = [MTLJSONAdapter modelOfClass:[SBAudioUpload class]
                                   fromJSONDictionary:JSON
                                                error:&err];
    
    it(@"should deserialize", ^{
    	expect(err).to.beNil();
        expect(obj).toNot.beNil();
    });
    
    it(@"should have transformed to proper types", ^{
    	expect(obj.postingAccountID).to.beKindOf(NSNumber.class);
    	expect(obj.commentCount).to.beKindOf(NSNumber.class);
        expect(obj.creationDate).to.beKindOf(NSDate.class);
        expect(obj.editURL).to.beKindOf(NSURL.class);
        expect(obj.exclusive).to.beKindOf(NSNumber.class);
        expect(obj.inModeration).to.beKindOf(NSNumber.class);
        expect(obj.likeCount).to.beKindOf(NSNumber.class);
        expect(obj.modificationDate).to.beKindOf(NSDate.class);
        expect(obj.shortURL).to.beKindOf(NSURL.class);
        expect(obj.sticky).to.beKindOf(NSNumber.class);
        expect(obj.title).to.beKindOf(NSString.class);
    	expect(obj.userID).to.beKindOf(NSNumber.class);
        expect(obj.userHasLiked).to.beKindOf(NSNumber.class);
    });
    
    it(@"should reserialize identically", ^{
    	NSDictionary *newJSON = [MTLJSONAdapter JSONDictionaryFromModel:obj];
        expect(newJSON).toNot.beNil();
        expect(newJSON).to.equal(JSON);
    });
});

SpecEnd