//
//  SBAnimationContainerView.h
//  CocoaBloc
//
//  Created by John Heaton on 9/5/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 The purpose of this class is to provide a superview for views that you wish
 to use in an AutoLayout scenario. This view uses standard layout in order to 
 ensure that the contained view will stay centered. Normally, a view with any 
 change to its frame, for example a transform, will not work well in an AutoLayout
 container view, as the constraints will cause it to jump around as it's constantly
 attempting to satisfy them while the frame of the view changes during animation.
 */
@interface SBAnimationContainerView : UIView

@property (nonatomic) UIView *animationView;
@property (nonatomic, assign) UIEdgeInsets animationViewInsets;

@end
