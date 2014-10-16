//
//  SBLogInViewModel.m
//  CocoaBloc
//
//  Created by John Heaton on 10/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBLogInViewModel.h"
#import "SBClient+Auth.h"

@interface SBLogInViewModel ()
@property (nonatomic, assign) BOOL logInEnabled;
@end

@implementation SBLogInViewModel

- (id)init {
    if ((self = [super init])) {
        RAC(self, logInEnabled) = [RACSignal combineLatest:@[RACObserve(self, username),
                                                             RACObserve(self, password)]
                                                    reduce:^id (NSString *username, NSString *password) {
                                                        return @(username.length > 0 && password.length > 0);
                                                    }];
    }
    return self;
}

- (RACSignal *)logIn {
    return [self.client logInWithUsername:self.username password:self.password];
}

@end
