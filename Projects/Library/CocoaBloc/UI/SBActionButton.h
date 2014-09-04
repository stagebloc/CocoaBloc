//
//  SBActionButton.h
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SBActionType) {
    SBActionTypeComment,
    SBActionTypeLike
};

/*
 A button that will bounce-animate on touch up and display an integer value as a result of
 selection of that button.
 */
@interface SBActionButton : UIButton

+ (instancetype)buttonWithActionType:(SBActionType)type;

/// This will apply certain default characteristics to the button
@property (nonatomic, assign) SBActionType actionType;

/// This number will be shown to the right of the image.
@property (nonatomic, assign) NSUInteger actionCount;

/*! 
 	@discussion
 	This will be added or subtracted to/from actionCount depending
    on the selected state.

    Example: on like buttons, this is set to one, as your selection
	will increment the value of total likes by that value.
 */
@property (nonatomic, assign) NSUInteger actionCountSelectionIncrease;

@end