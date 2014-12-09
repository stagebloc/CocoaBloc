//
//  SCPageView.h
//  CocoaBloc
//
//  Created by Mark Glagola on 11/7/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBPageView : UIView

/*
 YES to have the pageView fade out the labels
 to the right and left of the selectedLabel
 
 NO to have no label fading
 
 Default is YES.
 */
@property (nonatomic, assign) BOOL fadeOut;

@property (nonatomic, readonly, strong) NSArray *labels;

/*
 Responible for animating the view to the label at @index
 Uses @animationDuration when animating
 Cannot set index > @labels.count or index < 0
 Default = 0
 */
@property (nonatomic, assign) NSInteger index;

//Duration for animating index changes.
//Default = 0.4f
@property (nonatomic, assign) NSTimeInterval animationDuration;

//The textColor for the label at @index
//Default = fc_stageblocBlueColor
@property (nonatomic, copy) UIColor *selectedColor;

//The textColor for all labels except the label at @index
//Default = whiteColor
@property (nonatomic, copy) UIColor *deselectedColor;

/*
 Must contain 1 title or throws exception
 */
- (id) initWithTitles:(NSArray*)titles;

//same as setting @index but with declared duration
- (void) setIndex:(NSInteger)index duration:(NSTimeInterval)duration;

@end
