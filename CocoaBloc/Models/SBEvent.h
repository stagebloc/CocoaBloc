//
//  SBEvent.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 2/26/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBObject.h"

@class SBAccount, SBAddress;

@interface SBEvent : SBObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptiveText;
@property (nonatomic, copy) NSURL *shortURL;
@property (nonatomic) NSNumber *ticketPrice;
@property (nonatomic) NSURL *ticketLink;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSTimeZone *timeZone;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *attendingCount;

@property (nonatomic) NSNumber *accountID;
@property (nonatomic) SBAccount *account;

@property (nonatomic) SBAddress *location;

@property (nonatomic) NSNumber *userHasLiked;
@property (nonatomic) NSString *userIsAttending;

@end
