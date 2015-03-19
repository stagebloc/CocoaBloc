//
//  SBClient+Blog.h
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBBlog.h"

@interface SBClient (Blog)

/**
 Submits a blog post to an account, given a title and body.
 
 @param title max length: 150
 */
- (RACSignal *)postBlogWithTitle:(NSString *)title
                            body:(NSString *)body
         toAccountWithIdentifier:(NSNumber *)accountID;

@end
