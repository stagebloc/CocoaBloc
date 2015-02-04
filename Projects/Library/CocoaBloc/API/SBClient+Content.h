//
//  SBClient+Content.h
//  CocoaBloc
//
//  Created by John Heaton on 12/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Content)

- (RACSignal *)likeContent:(SBContent *)content;
- (RACSignal *)unlikeContent:(SBContent *)content;

- (RACSignal *)deleteContent:(SBContent *)content;

// supports offset/limit
- (RACSignal *)getUsersWhoLikeContent:(SBContent *)content parameters:(NSDictionary *)parameters;

/*!
 Gets a content object.
 @param identifier - content's id
 @param type - type of content (i.e. blog, photo, etc)
 @param accountIdentifier - account content is posted to
 */
- (RACSignal *)getContentWithIdentifier:(NSNumber *)identifier type:(NSString*)type forAccountWithIdentifier:(NSNumber *)accountIdentifier;

- (RACSignal *)flagContent:(SBContent *)content type:(NSString *)type reason:(NSString *)reason;

- (RACSignal *)flagContentWithIdentifier:(NSNumber *)contentIdentifier
                             contentType:(NSString *)contentType
                forAccountWithIdentifier:(NSNumber *)accountIdentifier
                                    type:(NSString *)type
                                  reason:(NSString *)reason;

@end
