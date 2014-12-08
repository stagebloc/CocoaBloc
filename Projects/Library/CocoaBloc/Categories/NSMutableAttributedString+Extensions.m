//
//  NSAttributedString+Extensions.m
//  CocoaBloc
//
//  Created by Mark Glagola on 12/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "NSMutableAttributedString+Extensions.h"

@implementation NSMutableAttributedString (Extensions)

- (void) removeAllAttributes {
    [self removeAllAttributesInRange:NSMakeRange(0, self.length)];
}

- (void) removeAllAttributesInRange:(NSRange)toRemoveRange {
    [self enumerateAttributesInRange:toRemoveRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self removeAttribute:key range:range];
        }];
    }];
}

@end
