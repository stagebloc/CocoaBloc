//
//  SBClient+User.m
//  CocoaBloc
//
//  Created by John Heaton on 9/8/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient+User.h"
#import "SBClient.h"
#import "SBClient+Private.h"
#import "NSObject+AssociatedObjects.h"
#import "RACSignal+JSONDeserialization.h"
#import "SBClient+Auth.h"
#import <RACAFNetworking.h>
#import <RACEXTScope.h>
#import "AFHTTPRequestOperationManager+File.h"
#import "NSData+Mime.h"

#define NSStringConstant(val) NSString *val = @#val

NSString *SBClientUserProfileUpdateParameterBio = @"bio";
NSString *SBClientUserProfileUpdateParameterBirthday = @"birthday";
NSString *SBClientUserProfileUpdateParameterEmailAddress = @"email";
NSString *SBClientUserProfileUpdateParameterUsername = @"username";
NSString *SBClientUserProfileUpdateParameterName = @"name";
NSString *SBClientUserProfileUpdateParameterGender = @"gender";

@implementation SBClient (User)

- (void)setAuthenticatedUser:(SBUser *)user {
    if (![user isEqual:self.authenticatedUser]) {
        [self willChangeValueForKey:@"authenticatedUser"];
        [self setAssociatedObject:user forKey:@"user" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        [self didChangeValueForKey:@"authenticatedUser"];
    }
}

- (SBUser *)authenticatedUser {
    return [self associatedObjectForKey:@"user"];
}

- (RACSignal *)getUserWithID:(NSNumber *)userID {
    return [[[self rac_GET:[NSString stringWithFormat:@"users/%d", userID.intValue] parameters:[self requestParametersWithParameters:nil]]
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

- (RACSignal *)getCurrentlyAuthenticatedUser {
    @weakify(self);
    return [[[[self rac_GET:@"users/me" parameters:[self requestParametersWithParameters:nil]]
            	cb_deserializeWithClient:self keyPath:@"data"]
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
    
    return [[self rac_POST:@"users/password/reset" parameters:[self requestParametersWithParameters:@{@"email":emailAddress}]]
            	setNameWithFormat:@"Password reset (%@)", emailAddress];
}

- (RACSignal *)updateUserLocationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    return [[self rac_POST:@"users/me/location/update" parameters:[self requestParametersWithParameters:@{@"latitude":@(coordinates.latitude),@"longitude":@(coordinates.longitude)}]]
            	setNameWithFormat:@"Update coordinates"];
}

- (RACSignal *)updateAuthenticatedUserWithParameters:(NSDictionary *)parameters {
    return [self updateAuthenticatedUserWithParameters:parameters photoData:nil photoProgressSignal:nil];
}

- (RACSignal *)updateAuthenticatedUserWithPhotoData:(NSData*)photoData progressSignal:(RACSignal**)progressSignal {
    return [self updateAuthenticatedUserWithParameters:nil photoData:photoData photoProgressSignal:progressSignal];
}

- (RACSignal *)updateAuthenticatedUserWithParameters:(NSDictionary *)parameters photoData:(NSData*)photoData photoProgressSignal:(RACSignal**)photoProgressSignal {
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
    
    if (!photoData) {
        return [[self rac_POST:@"users/me" parameters:[self requestParametersWithParameters:p]]
                    setNameWithFormat:@"Update authenticated user (%@)", self.authenticatedUser];
    }
    
    NSString* const fileName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:@"users/me"].absoluteString;
    
    // verify that the mime type is valid and supported by us
    NSString *mime = [photoData photoMime];
    if (!mime) {
        return [RACSignal error:[NSError errorWithDomain:SBCocoaBlocErrorDomain code:kSBCocoaBlocErrorInvalidFileNameOrMIMEType userInfo:nil]];
    }

    NSError *err;
    AFHTTPRequestOperation *op =
    [self fileRequestFromData:photoData
                         name:@"photo"
                     fileName:fileName
                     mimeType:mime
                          url:endpointLocation
                   parameters:[p copy]
                        error:&err
               progressSignal:photoProgressSignal];
    
    if (err) {
        return [RACSignal error:err];
    }
    
    return [[[self enqueueRequestOperation:op]
                cb_deserializeWithClient:self keyPath:@"data"]
                setNameWithFormat:@"Update authenticated user (%@) with new photo", self.authenticatedUser];
}

@end
