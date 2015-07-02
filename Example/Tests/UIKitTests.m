//
//  CocoaBlocTests.m
//  CocoaBlocTests
//
//  Created by John Heaton on 03/30/2015.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <CocoaBloc/SBDeleteActivity.h>
#import <CocoaBloc/SBFlagActivity.h>
#import <CocoaBloc/SBBanUserActivity.h>
#import <CocoaBloc/SBBlog+UIActivityItemSource.h>
#import <CocoaBloc/SBStatus+UIActivityItemSource.h>
#import <CocoaBloc/SBVideo+UIActivityItemSource.h>
#import <CocoaBloc/SBComment+UIActivityItemSource.h>

#import <CocoaBloc/CocoaBloc.h>

SpecBegin(UIKit)

describe(@"Image Resources", ^{
    it(@"should have activity images", ^{
        
        // Verifies that our image resources for these icons are loading properly
        expect([SBDeleteActivity new].activityImage).toNot.beNil();
        expect([SBFlagActivity new].activityImage).toNot.beNil();
        expect([SBBanUserActivity new].activityImage).toNot.beNil();
    });
});

describe(@"Model Activities", ^{
    it(@"should have our models conforming to UIActivityItemSource", ^{
        expect([SBVideo conformsToProtocol:@protocol(UIActivityItemSource)]).to.beTruthy();
        expect([SBStatus conformsToProtocol:@protocol(UIActivityItemSource)]).to.beTruthy();
        expect([SBBlog conformsToProtocol:@protocol(UIActivityItemSource)]).to.beTruthy();
        expect([SBComment conformsToProtocol:@protocol(UIActivityItemSource)]).to.beTruthy();
    });
    
    it(@"should return models directly for our activity types", ^{
        
        // We expect that, for flag/delete activity classes to work properly,
        // the models will return themselves in order to be passed to the appropriate API endpoint.
        
        // So, create some empty models
        SBBlog *blog = SBBlog.new;
        SBStatus *status = SBStatus.new;
        SBComment *comment = SBComment.new;
        SBVideo *video = SBVideo.new;
        
        // Check against delete type
        expect([blog activityViewController:nil itemForActivityType:SBDeleteActivityType]).to.equal(blog);
        expect([status activityViewController:nil itemForActivityType:SBDeleteActivityType]).to.equal(status);
        expect([video activityViewController:nil itemForActivityType:SBDeleteActivityType]).to.equal(video);
        expect([comment activityViewController:nil itemForActivityType:SBDeleteActivityType]).to.equal(comment);

        // Check against flag type
        expect([blog activityViewController:nil itemForActivityType:SBFlagActivityType]).to.equal(blog);
        expect([status activityViewController:nil itemForActivityType:SBFlagActivityType]).to.equal(status);
        expect([video activityViewController:nil itemForActivityType:SBFlagActivityType]).to.equal(video);
        expect([comment activityViewController:nil itemForActivityType:SBFlagActivityType]).to.equal(comment);
    });
    
    it(@"should have valid constants", ^{
        
        // Verifies that we haven't forgotten to define any declared constants
        expect(SBDeleteActivityType).toNot.beNil();
        expect(SBDeleteActivityDidDeleteContentOrCommentNotification).toNot.beNil();
        expect(SBFlagActivityType).toNot.beNil();
        expect(SBBanUserActivityType).toNot.beNil();
    });
});

SpecEnd