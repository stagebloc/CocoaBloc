//
//  SBPhoto.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBModifiableContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBPhoto : SBModifiableContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSURL *thumbnailURL;
@property (nonatomic) NSURL *smallURL;
@property (nonatomic) NSURL *mediumURL;
@property (nonatomic) NSURL *largeURL;
@property (nonatomic) NSURL *originalURL;
@property (nonatomic) NSNumber *isSticky;

@end

NS_ASSUME_NONNULL_END
