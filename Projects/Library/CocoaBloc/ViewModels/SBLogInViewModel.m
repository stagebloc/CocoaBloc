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

@synthesize client;

- (instancetype)initWithClient:(SBClient *)c {
    if ((self = [self init])) {
        self.client = c;
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        _logInCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self, username),
                                                                                       RACObserve(self, password)]
                                                                              reduce:^NSNumber *(NSString *usernameOrEmail, NSString *password) {
                                                                                  return @(usernameOrEmail.length > 0 && password.length > 0);
                                                                              }]
                                                signalBlock:^RACSignal *(id input) {
                                                    return [self.client logInWithUsername:self.username password:self.password];
                                                }];
        self.logInCommand.allowsConcurrentExecution = NO;
    }
    return self;
}

@end
