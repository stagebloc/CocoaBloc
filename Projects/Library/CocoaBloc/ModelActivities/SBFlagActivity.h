//
//  SBFlagActivity.h
//  Pods
//
//  Created by John Heaton on 2/2/15.
//
//

#import <UIKit/UIKit.h>
#import "SBClient.h"

@interface SBFlagActivity : UIActivity

- (instancetype)initWithClient:(SBClient *)client;

@end

extern NSString *const SBFlagActivityType;