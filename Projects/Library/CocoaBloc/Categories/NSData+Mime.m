//
//  NSData+Mime.m
//  CocoaBloc
//
//  Created by Mark Glagola on 1/21/15.
//  Copyright (c) 2015 StageBloc. All rights reserved.
//

#import "NSData+Mime.h"

@implementation NSData (Mime)

- (NSString*) photoMime {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xff:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4d:
            return @"image/tiff";
        default:
            return nil;
    }
}

@end
