//
//  SBVideoPlaybackView.h
//  Pods
//
//  Created by David Warner on 12/4/14.
//
//

#import <UIKit/UIKit.h>

@interface SBVideoPlaybackView : UIView

- (instancetype) initWithFrame:(CGRect)frame videoURL:(NSURL*)videoURL;

- (void) play;
- (void) pause;
- (void) restart;

@end
