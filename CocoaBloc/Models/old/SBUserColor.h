//
//  SBColor.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/16/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

#ifndef SBUserColor
#if TARGET_OS_IPHONE
@class UIColor;
#define SBUserColor UIColor
#else
@class NSColor;
#define SBUserColor NSColor
#endif
#endif
