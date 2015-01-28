//
//  SBClient+Content.h
//  CocoaBloc
//
//  Created by John Heaton on 12/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

extern NSString * const SBAPIMethodParameterFlagContent;

/*
 SBAPIMethodParameterFlagContent preset values which can be used for
 reasons why someone flagged a piece of content
*/
extern NSString * const SBAPIMethodParameterFlagContentValueOffensive;
extern NSString * const SBAPIMethodParameterFlagContentValuePrejudice;
extern NSString * const SBAPIMethodParameterFlagContentValueCopyright;
extern NSString * const SBAPIMethodParameterFlagContentValueDuplicate;

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

- (RACSignal *)flagContent:(SBContent *)content reason:(NSString *)reason;

- (RACSignal *)flagContentWithIdentifier:(NSNumber *)contentIdentifier
                             contentType:(NSString *)contentType
                forAccountWithIdentifier:(NSNumber *)accountIdentifier
                                  reason:(NSString *)reason;

@end
