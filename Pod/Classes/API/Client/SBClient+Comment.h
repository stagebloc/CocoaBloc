//
//  SBClient+Comment.h
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBComment.h"

@interface SBClient (Comment)

// supports limit/offset
- (RACSignal *)getCommentsForContent:(SBContent *)content parameters:(NSDictionary *)parameters;

- (RACSignal *)getRepliesToComment:(SBComment *)comment parameters:(NSDictionary *)parameters;
- (RACSignal *)deleteComment:(SBComment *)comment;

- (RACSignal *)postCommentWithText:(NSString *)text onContent:(SBContent *)content parameters:(NSDictionary *)parameters;
- (RACSignal *)postCommentWithText:(NSString *)text inReplyToComment:(SBComment *)comment parameters:(NSDictionary *)parameters;

- (RACSignal *)getCommentWithID:(NSNumber *)commentID forContent:(SBContent *)content;

- (RACSignal *)flagComment:(SBComment *)comment type:(NSString *)type reason:(NSString *)reason;
- (RACSignal *)flagCommentWithIdentifier:(NSNumber *)commentIdentifier
                             contentType:(NSString *)contentType
                forAccountWithIdentifier:(NSNumber *)accountIdentifier
                                    type:(NSString *)type
                                  reason:(NSString *)reason;

@end
