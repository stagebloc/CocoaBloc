//
//  SBUserPhoto.m
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/16/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBUserPhoto.h"

@implementation SBUserPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"width"			: @"width",
			 @"height"			: @"height",
			 @"originalURL"		: @"images.original_url",
			 @"smallURL"		: @"images.small_url",
			 @"mediumURL"		: @"images.medium_url",
			 @"largeURL"		: @"images.large_url",
			 @"thumbnailURL"	: @"images.thumbnail_url",
			 @"kind"			: @"kind"};
}

- (BOOL)isEqual:(id)object {
	__block BOOL equal = YES;
	NSArray *properties = [[[self class] JSONKeyPathsByPropertyKey] allKeys];
	[properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
		if (![object respondsToSelector:NSSelectorFromString(key)] || ![[object valueForKey:key] isEqual:[self valueForKey:key]]) {
			equal = NO;
			*stop = YES;
		}
	}];
	return equal;
}

@end
