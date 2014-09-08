//
//  SBClient+User.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+User.h"

@implementation SBClient (User)

- (RACSignal *)getUserWithID:(NSNumber *)userID {
    return [[[self rac_GET:[NSString stringWithFormat:@"users/%d", userID.intValue] parameters:nil]
             map:^id(NSDictionary *response) {
                 SBUser *user = [MTLJSONAdapter
                                 modelOfClass:[SBUser class]
                                 fromJSONDictionary:response[@"data"]
                                 error:nil];
                 
                 if ([user.identifier isEqual:self.user.identifier]) {
                     user.adminAccounts = self.user.adminAccounts;
                 }
                 
                 return user;
             }]
            setNameWithFormat:@"Get user with ID: %d", userID.intValue];
}

- (RACSignal *)getMe {
    @weakify(self);
    return [[[[self rac_GET:@"users/me" parameters:nil]
              map:^id(NSDictionary *response) {
                  // deserialize
                  return [MTLJSONAdapter modelOfClass:[SBUser class]
                                   fromJSONDictionary:response[@"data"]
                                                error:nil];
              }]
             doNext:^(SBUser *user) {
                	@strongify(self);
                 
                 SBUser *oldMe = self.user;
                 
                 // set the new user
                 self.user = user;
                 
                 // if it's the same user, use the new response data
                 // and add in the current admin acccounts
                 // Why? this response doesn't return admin accounts
                 if ([oldMe.identifier isEqual:user.identifier]) {
                     self.user.adminAccounts = oldMe.adminAccounts;
                 }
             }]
            setNameWithFormat:@"Get \"me\""];
}

@end
