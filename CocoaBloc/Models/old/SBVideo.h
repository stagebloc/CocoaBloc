//
//  SBVideoUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBModifiableContent.h"
#import "SBAccountPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@class SBClient;
@interface SBVideo : SBModifiableContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic, nullable) NSURL *videoCDNURL;

@property (nonatomic) NSNumber *photoID;
@property (nonatomic, nullable) SBAccountPhoto *photo;

@end

NS_ASSUME_NONNULL_END
