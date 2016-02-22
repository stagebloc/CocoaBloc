//
//  SBAudioUpload.h
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"

@interface SBAudio : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSURL *editURL;
@property (nonatomic, copy) NSURL *streamURL;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *lyrics;

@end
