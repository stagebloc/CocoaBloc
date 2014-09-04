//
//  SBActionButton.h
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SBActionButtonType) {
    SBActionButtonTypeComment,
    SBActionButtonTypeLike
};

@interface SBActionButton : UIButton

@property (nonatomic, assign) SBActionButtonType type;
@property (nonatomic, assign) NSUInteger actionCount;

@end