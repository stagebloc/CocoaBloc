//
//  SBPhoto.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"

@interface SBPhoto : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSURL *thumbnailURL;
@property (nonatomic) NSURL *smallURL;
@property (nonatomic) NSURL *mediumURL;
@property (nonatomic) NSURL *largeURL;
@property (nonatomic) NSURL *originalURL;

@end
