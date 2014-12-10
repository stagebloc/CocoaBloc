//
//  SBClient+Comment.h
//  CocoaBloc
//
//  Created by John Heaton on 12/10/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"

@interface SBClient (Comment)

// supports limit/offset
- (RACSignal *)getCommentsForContent:(SBContent *)content parameters:(NSDictionary *)parameters;

@end
