//
//  NSURL+Camera.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/17/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Camera)

+ (instancetype) randomDocumentsFileURLWithPrefix:(NSString*)prefix extension:(NSString*)extension;

+ (instancetype) randomTemporaryFileURLWithPrefix:(NSString*)prefix extension:(NSString*)extension;
+ (instancetype) randomTemporaryMP4FileURLWithPrefix:(NSString*)prefix;

@end
