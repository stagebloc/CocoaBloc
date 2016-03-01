//
//  SBVideoUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBModifiableContent.h"
#import "SBPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@class SBClient;
@interface SBVideo : SBModifiableContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic, nullable) NSURL *videoCDNURL;

@property (nonatomic) NSNumber *photoID;
@property (nonatomic, nullable) SBPhoto *photo;

@end

NS_ASSUME_NONNULL_END
