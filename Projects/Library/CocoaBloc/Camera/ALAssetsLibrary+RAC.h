//
//  ALAssetsLibrary+RAC.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@class RACSignal;

@interface ALAssetsLibrary (RAC)

- (RACSignal*) fetchGroupsWithTypes:(ALAssetsGroupType)types;

@end
