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

@end
