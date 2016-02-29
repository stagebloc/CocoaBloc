//
//  SBBlog.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "SBPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBBlog : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *strippedBody;
@property (nonatomic, copy) NSString *category;

@end

NS_ASSUME_NONNULL_END
