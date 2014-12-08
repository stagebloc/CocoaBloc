//
//  NSAttributedString+Extensions.h
//  CocoaBloc
//
//  Created by Mark Glagola on 12/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Extensions)

- (void) removeAllAttributes;
- (void) removeAllAttributesInRange:(NSRange)toRemoveRange;

@end
