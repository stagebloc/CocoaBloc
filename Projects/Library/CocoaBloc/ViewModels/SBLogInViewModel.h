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
#import "SBAPIViewModel.h"

@interface SBLogInViewModel : NSObject <SBAPIViewModel>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, readonly) RACCommand *logInCommand;

@end
