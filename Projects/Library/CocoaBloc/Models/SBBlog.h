//
//  SBBlog.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"

@interface SBBlog : SBContent <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *dateModified;
@property (nonatomic, strong, getter = isSticky) NSNumber *sticky;
@property (nonatomic, strong, getter = isExclusive) NSNumber *exclusive;
@property (nonatomic, copy) NSString *relatedContentTag;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *category;

@end
