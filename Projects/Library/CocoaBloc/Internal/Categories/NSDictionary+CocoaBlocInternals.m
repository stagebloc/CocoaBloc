//
//  NSDictionary+CocoaBlocInternals.m
//  CocoaBloc
//
//  Created by John Heaton on 7/18/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "NSDictionary+CocoaBlocInternals.h"

@implementation NSDictionary (CocoaBlocInternals)

- (NSDictionary *)addEntriesFromDictionary:(NSDictionary *)dict {
	NSMutableDictionary *m = self.mutableCopy;
	[m addEntriesFromDictionary:dict];
	return m.copy;
}

@end
