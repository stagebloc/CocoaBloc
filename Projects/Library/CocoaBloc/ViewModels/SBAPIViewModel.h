//
//  SBAPIViewModel.h
//  Pods
//
//  Created by John Heaton on 12/12/14.
//
//

#import <Foundation/Foundation.h>

@protocol SBAPIViewModel <NSObject>

@required
- (instancetype)initWithClient:(SBClient *)client;

@property (nonatomic, strong) SBClient *client;

@end
