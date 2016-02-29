//
//  SBEvent.m
//  CocoaBloc
//
//  Created by Dan Zimmerman on 2/26/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBEvent.h"

#import "MTLValueTransformer+CocoaBloc.h"
#import "NSDateFormatter+CocoaBloc.h"

@implementation SBEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"title":				@"title",
			 @"descriptiveText":	@"description",
			 @"shortURL":			@"short_url",
			 @"ticketPrice":		@"ticket_price",
			 @"ticketLink":			@"ticket_link",
			 @"startDate":			@"start_date_time",
			 @"endDate":			@"end_date_time",
			 @"timeZone":			@"timezone",
			 @"commentCount":		@"comment_count",
			 @"likeCount":			@"like_count",
			 @"attendingCount":		@"attending_count",
			 @"location":			@"location",
			 @"accountID":			@"account",
			 @"account":			@"account",
			 @"userHasLiked":		@"user_has_liked",
			 @"userIsAttending":	@"user_is_attending"
			 };
}

+ (MTLValueTransformer *)shortURLJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)ticketLinkJSONTransformer {
	return [MTLValueTransformer reversibleStringToURLTransformer];
}

+ (MTLValueTransformer *)startDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatterWithTimeZone]];
}

+ (MTLValueTransformer *)endDateJSONTransformer {
	return [MTLValueTransformer reversibleStringToDateTransformerWithFormatter:[NSDateFormatter CocoaBlocJSONDateFormatterWithTimeZone]];
}

+ (MTLValueTransformer *)timeZoneJSONTransformer {
	return [MTLValueTransformer reversibleStringToTimeZoneTransformer];
}

+ (MTLValueTransformer *)accountIDJSONTransformer {
	return [MTLValueTransformer reversibleModelIDOnlyTransformer];
}

+ (MTLValueTransformer *)accountJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)locationJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

@end
