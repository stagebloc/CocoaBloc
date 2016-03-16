//
//  SBUserPhoto.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/16/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBUserPhoto : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;

// May be null from server or if
@property (nonatomic, nullable) NSURL *thumbnailURL;
@property (nonatomic, nullable) NSURL *smallURL;
@property (nonatomic, nullable) NSURL *mediumURL;
@property (nonatomic, nullable) NSURL *largeURL;
@property (nonatomic, nullable) NSURL *originalURL;

@property (nonatomic, nullable) NSString *kind;

@end

NS_ASSUME_NONNULL_END
