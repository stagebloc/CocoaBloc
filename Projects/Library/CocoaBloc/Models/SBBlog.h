//
//  SBBlog.h
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBContent.h"
#import "SBPhoto.h"

@interface SBBlog : SBContent <MTLJSONSerializing>

@property (nonatomic, copy) NSString *relatedContentTag;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *category;
@property (nonatomic) SBPhoto *photo;

@end
