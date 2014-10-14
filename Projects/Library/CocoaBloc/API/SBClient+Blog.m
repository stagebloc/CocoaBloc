//
//  SBClient+Blog.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+Blog.h"

@implementation SBClient (Blog)

- (RACSignal *)getUsersLikingBlog:(SBBlog *)blog {
    return [RACSignal empty];
#warning imp
}

- (RACSignal *)deleteBlog:(SBBlog *)blog {
    return [RACSignal empty];
#warning imp
}

@end
