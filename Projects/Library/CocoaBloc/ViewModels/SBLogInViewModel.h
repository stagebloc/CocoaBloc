//
//  SBLogInViewModel.h
//  CocoaBloc
//
//  Created by John Heaton on 10/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SBClient.h"

@interface SBLogInViewModel : NSObject

- (instancetype)initWithClient:(SBClient *)client;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, readonly) BOOL logInEnabled;

@property (nonatomic, strong) SBClient *client;

- (RACSignal *)logIn;

@end
