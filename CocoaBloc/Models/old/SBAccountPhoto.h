//
//  SBPhoto.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 Fullscreen Direct. All rights reserved.
//

#import "SBModifiableContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAccountPhoto : SBModifiableContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;

// May be null from server or if
@property (nonatomic, nullable) NSURL *thumbnailURL;
@property (nonatomic, nullable) NSURL *smallURL;
@property (nonatomic, nullable) NSURL *mediumURL;
@property (nonatomic, nullable) NSURL *largeURL;
@property (nonatomic, nullable) NSURL *originalURL;

@property (nonatomic) NSNumber *isSticky;

@end

NS_ASSUME_NONNULL_END
