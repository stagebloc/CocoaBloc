//
//  SBClient+Content.h
//  CocoaBloc
//
//  Created by John Heaton on 12/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Content)

- (RACSignal *)likeContent:(SBContent *)content onBehalfOfAccount:(SBAccount *)account;
- (RACSignal *)unlikeContent:(SBContent *)content onBehalfOfAccount:(SBAccount *)account;

// supports offset/limit
- (RACSignal *)getUsersWhoLikeContent:(SBContent *)content;

@end
