//
//  SBVideoUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 12/3/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "SBPhoto.h"

@interface SBVideo : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSURL *videoCDNURL;
@property (nonatomic) SBPhoto *photo;

@end
