//
//  SCAssetsManager.h
//  StitchCam
//
//  Created by David Warner on 9/23/14.
//  Copyright (c) 2014 David Skuza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@class SBAssetGroup;

@interface SBAssetsManager : NSObject

/*!
 Fetches the last photo taken by the user
 from their local photos.
 */
-(RACSignal *)fetchLastPhoto;

/*!
 Fetches all the user's local SBAssetGroups
 and sendNext: sends an NSArray of the fetched
 SBAsset groups.
 */
-(RACSignal*)fetchGroupsList;

/*!
 Fetches all the user's local SBAssetGroups
 and sendNext: sends the next SBAssetGroup that
 was just fetched.
 */
-(RACSignal *)fetchGroups;

@end
