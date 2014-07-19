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
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *smallURL;
@property (nonatomic, strong) NSURL *mediumURL;
@property (nonatomic, strong) NSURL *largeURL;
@property (nonatomic, strong) NSURL *originalURL;

@end
