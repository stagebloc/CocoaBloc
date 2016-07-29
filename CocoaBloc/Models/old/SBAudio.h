//
//  SBAudioUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBModifiableContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAudio : SBModifiableContent <MTLJSONSerializing>

@property (nonatomic, copy, nullable) NSURL *editURL;
@property (nonatomic, copy) NSURL *streamURL;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *lyrics;
@property (nonatomic) NSNumber *isSticky;

@end

NS_ASSUME_NONNULL_END
