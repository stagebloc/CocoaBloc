//
//  PHPhotoLibrary+RAC.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Photos/Photos.h>

@class RACSignal;

@interface PHPhotoLibrary (RAC)

+ (RACSignal*) rac_requestAccess;

@end
