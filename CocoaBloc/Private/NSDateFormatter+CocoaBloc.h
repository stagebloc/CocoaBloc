//
//  NSDateFormatter+CocoaBloc.h
//  CocoaBloc
//
//  Created by John Heaton on 7/29/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CocoaBloc)

//+ (nonnull NSDateFormatter *)CocoaBlocJSONDateFormatter;
// Used e.g. in convertEvent(\AccountEvent $event)
+ (nonnull NSDateFormatter *)CocoaBlocJSONDateFormatterWithTimeZone;

@end
