//
//  SBEvent.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 2/26/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBContentStreamObject.h"

NS_ASSUME_NONNULL_BEGIN

@class SBAccount, SBAddress;

@interface SBEvent : SBContentStreamObject

@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic) NSNumber *ticketPrice;
@property (nonatomic) NSURL *ticketLink;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSTimeZone *timeZone;
@property (nonatomic) NSNumber *attendingCount;

@property (nonatomic, nullable) SBAddress *location;

@property (nonatomic, nullable) NSString *userIsAttending;

@end

NS_ASSUME_NONNULL_END
