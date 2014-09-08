//
//  SBLoadingImageView.h
//  CocoaBloc
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBLoadingImageView : UIImageView

- (void)downloadImageAtURL:(NSURL *)url;

@property (nonatomic, readonly) BOOL downloading;

@property (nonatomic, assign) BOOL drawsProgressStroke;
@property (nonatomic, assign) CGFloat progressStrokeWidth;

@property (nonatomic, assign) BOOL bounceOnFinish;

@end
