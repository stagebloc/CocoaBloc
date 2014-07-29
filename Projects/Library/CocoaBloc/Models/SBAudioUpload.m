//
//  SBAudioUpload.m
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBAudioUpload.h"
#import <Mantle/Mantle.h>
#import <EXTKeyPathCoding.h>

@implementation SBAudioUpload

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:
			@{@"postingAccountID" 	: @"account",
              @"commentCount" 		: @"comment_count",
              @"creationDate" 		: @"created",
              @"editURL" 			: @"edit_url",
              @"exclusive" 		 	: @"exclusive",
              @"inModeration" 	 	: @"in_moderation",
              @"likeCount" 		 	: @"like_count",
              @"modificationDate"	: @"modified",
              @"shortURL" 		 	: @"short_url",
              @"sticky" 				: @"sticky",
              @"title" 				: @"title",
              @"userID" 			 	: @"user",
              @"userHasLiked" 	 	: @"user_has_liked"}];
}

@end
