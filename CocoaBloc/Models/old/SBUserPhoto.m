//
//  SBUserPhoto.m
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
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

@end
