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
			 @"descriptiveText":	@"description",
			 @"ticketPrice":		@"ticket_price",
			 @"ticketLink":			@"ticket_link",
			 @"startDate":			@"start_date_time",
			 @"endDate":			@"end_date_time",
			 @"timeZone":			@"timezone",
			 @"attendingCount":		@"attending_count",
			 @"location":			@"location",
			 @"userIsAttending":	@"user_is_attending"
			 };
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

+ (MTLValueTransformer *)locationJSONTransformer {
	return [MTLValueTransformer reversibleModelJSONOnlyTransformer];
}

+ (MTLValueTransformer *)userIsAttendingJSONTransformer {
	return [MTLValueTransformer reversibleEventAttendingStatusTransformer];
}

@end
