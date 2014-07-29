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
#import "SBUser.h"

#if TARGET_OS_IPHONE
@import UIKit.UIColor;
#else
@import AppKit;
#endif

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

describe(@"User", ^{
	NSError *err;
    NSDictionary *JSON = @{
                           @"bio" : @"jhghjh",
                           @"birthday" : @"1995-07-05",
                           @"color" : @"70,170,255",
                           @"created" : @"2009-10-27 14:29:16",
                           @"email" : @"hi@stagebloc.com",
                           @"gender" : @"male",
                           @"id" : @8,
                           @"name" : @"Josh Holat",
                           @"photo" : @{
                               @"height" : @169,
                               @"images" : @{
                               @"large_url" : @"http://cdn-staging.stagebloc.com/local/photos/users/8/large/20140326_190304_8_70.jpeg",
                               @"medium_url" : @"http://cdn-staging.stagebloc.com/local/photos/users/8/medium/20140326_190304_8_70.jpeg",
                               @"original_url" : @"http://cdn-staging.stagebloc.com/local/photos/users/8/original/20140326_190304_8_70.jpeg",
                               @"small_url" : @"http://cdn-staging.stagebloc.com/local/photos/users/8/small/20140326_190304_8_70.jpeg",
                               @"thumbnail_url" : @"http://cdn-staging.stagebloc.com/local/photos/users/8/thumbnail/20140326_190304_8_70.jpeg"
                               },
                               @"width" : @160
                           },
                           @"url" : @"https://stagebloc.dev/user/joshholatdudemanman",
                           @"username" : @"joshholatdudemanman"
                           };
    
    SBUser *obj = [MTLJSONAdapter modelOfClass:[SBUser class]
                            fromJSONDictionary:JSON
                                         error:&err];
    
    it(@"should deserialize", ^{
    	expect(err).to.beNil();
        expect(obj).toNot.beNil();
    });
    
    it(@"should have transformed to proper types", ^{
        Class c;
#if TARGET_OS_IPHONE
        c = [UIColor class];
#else
        c = [NSColor class];
#endif
        expect(obj.color).to.beKindOf(c);
        
        expect(obj.bio).to.beKindOf(NSString.class);
        expect(obj.birthday).to.beKindOf(NSDate.class);
        expect(obj.color).to.beKindOf(UIColor.class);
        expect(obj.creationDate).to.beKindOf(NSDate.class);
        expect(obj.emailAddress).to.beKindOf(NSString.class);
        expect(obj.gender).to.beKindOf(NSString.class);
        expect(obj.name).to.beKindOf(NSString.class);
        expect(obj.URL).to.beKindOf(NSURL.class);
        expect(obj.username).to.beKindOf(NSString.class);
    });
    
    it(@"should reserialize identically", ^{
    	NSDictionary *newJSON = [MTLJSONAdapter JSONDictionaryFromModel:obj];
        expect(newJSON).toNot.beNil();
        expect(newJSON).to.equal(JSON);
    });
});

SpecEnd