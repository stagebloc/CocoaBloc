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
#import "RACSignal+JSONDeserialization.h"
#import "SBClient+Auth.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>

#define NSStringConstant(val) NSString *val = @#val

NSString *SBClientUserProfileUpdateParameterBio = @"bio";
NSString *SBClientUserProfileUpdateParameterBirthday = @"birthday";
NSString *SBClientUserProfileUpdateParameterEmailAddress = @"email";
NSString *SBClientUserProfileUpdateParameterUsername = @"username";
NSString *SBClientUserProfileUpdateParameterName = @"name";
NSString *SBClientUserProfileUpdateParameterGender = @"gender";

@implementation SBClient (User)

- (void)setAuthenticatedUser:(SBUser *)user {
    [self willChangeValueForKey:@"authenticatedUser"];
    [self setAssociatedObject:user forKey:@"user" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self didChangeValueForKey:@"authenticatedUser"];
}

- (SBUser *)authenticatedUser {
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
                 
                 	if ([user.identifier isEqual:self.authenticatedUser.identifier]) {
                     	user.adminAccounts = self.authenticatedUser.adminAccounts;
                 	}
                 
                 	return user;
             	}]
            	setNameWithFormat:@"Get user with ID: %d", userID.intValue];
}

- (RACSignal *)getAuthenticatedUser {
    @weakify(self);
    return [[[[self rac_GET:@"users/me" parameters:nil]
            	cb_deserializeWithClient:self modelClass:[SBUser class] keyPath:@"data"]
             	doNext:^(SBUser *user) {
                	@strongify(self);
                 
                 	SBUser *oldMe = self.authenticatedUser;
                 
                 	// set the new user
                 	self.authenticatedUser = user;
                 
                 	// if it's the same user, use the new response data
                 	// and add in the current admin acccounts
                 	// Why? this response doesn't return admin accounts
                 	if ([oldMe.identifier isEqual:user.identifier]) {
                     	self.authenticatedUser.adminAccounts = oldMe.adminAccounts;
                 	}
             	}]
            	setNameWithFormat:@"Get \"authenticated user\""];
}

- (RACSignal *)sendPasswordResetToEmail:(NSString *)emailAddress {
    NSParameterAssert(emailAddress);
    
    return [[self rac_POST:@"users/password/reset" parameters:@{@"email":emailAddress}]
            	setNameWithFormat:@"Password reset (%@)", emailAddress];
}

- (RACSignal *)updateUserLocationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    return [[self rac_POST:@"users/me/location/update" parameters:@{@"latitude":@(coordinates.latitude),@"longitude":@(coordinates.longitude)}]
            	setNameWithFormat:@"Update coordinates"];
}

- (RACSignal *)updateAuthenticatedUserWithParameters:(NSDictionary *)parameters {
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
    
    return [[self rac_POST:@"users/me" parameters:p]
            	setNameWithFormat:@"Update authenticated user (%@)", self.authenticatedUser];
}

@end
