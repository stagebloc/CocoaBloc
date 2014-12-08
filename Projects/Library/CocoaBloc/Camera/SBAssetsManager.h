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

-(RACSignal *)fetchLastPhoto;

//sendNext is NSArray of SBAssetGroup objects
//and has only one sendNext: call followed by
//sendCompletion
-(RACSignal*)fetchAlbumsArray;

//sendNext: is SBAssetGroup object and will
//continue to sendNext: until completion block
//is called
-(RACSignal *)fetchAlbums;

@end
