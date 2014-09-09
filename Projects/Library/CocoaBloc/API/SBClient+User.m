//
//  SBClient+User.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+User.h"
#import "SBClient.h"
#import "NSObject+AssociatedObjects.h"
#import "SBClient+Auth.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>

@implementation SBClient (User)

- (void)setUser:(SBUser *)user {
    [self willChangeValueForKey:@"user"];
    [self setAssociatedObject:user forKey:@"user" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self didChangeValueForKey:@"user"];
}

- (SBUser *)user {
    return [self associatedObjectForKey:@"user"];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    if ([theKey isEqualToString:@"user"]) {
        return NO;
    }
    
    return [super automaticallyNotifiesObserversForKey:theKey];
}

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

- (RACSignal *)sendPasswordResetToEmail:(NSString *)emailAddress {
    NSParameterAssert(emailAddress);
    
    return [self rac_POST:@"users/password/reset" parameters:@{@"email":emailAddress}];
}

- (RACSignal *)updateUserLocationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    return [self rac_POST:@"users/me/location/update" parameters:@{@"latitude":@(coordinates.latitude),@"longitude":@(coordinates.longitude)}];
}

- (RACSignal *)updateUserProfileWithParameters:(NSDictionary *)parameters {
    NSParameterAssert(parameters);
    NSAssert(parameters.count != 0, @"Passing an empty parameters dictionary is not allowed.");
    
    // This is done so that we ensure only the keys we accept are in this dictionary.
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    id val;
#define SAFE_ASSIGN(key) if((val = parameters[key])) p[key] = val;
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterBio);
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterUsername);
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterName);
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterGender);
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterEmailAddress);
    SAFE_ASSIGN(SBClientUserProfileUpdateParameterBirthday);
#undef SAFE_ASSIGN
    
    return [self rac_POST:@"users/me" parameters:p];
}

@end
