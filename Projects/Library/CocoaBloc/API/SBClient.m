//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import <RACAFNetworking.h>

@interface SBClient ()
@property (nonatomic, assign, readwrite) BOOL authenticated;
@property (nonatomic, copy, readwrite) NSString *token;
@end

@implementation SBClient

// global client id/secret (global is it should be one per app)
static NSString *SBClientID, *SBClientSecret;

+ (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
	SBClientID = clientID.copy;
	SBClientSecret = clientSecret.copy;
}

- (id)init {
	self = [super initWithBaseURL:[NSURL URLWithString:
#ifdef DEBUG
								   @"https://api.stagebloc.dev/v1"
#else
								   @"https://api.stagebloc.com/v1"
#endif
								   ]];
	if (self) {
		self.securityPolicy.allowInvalidCertificates = YES; // dave says this is a dragon's leash
	}

	return self;
}

- (void)setToken:(NSString *)token {
	if (![token isEqual:self.token]) { // only change if it's different
		
		// keep the KVO compliance for observing token
		[self willChangeValueForKey:@"token"];
		
		// clear it if nil
		if (!token) {
			[self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        } else {
			// else set it
			_token = token.copy;
			[self.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:@"Authorization"];
		}
		[self didChangeValueForKey:@"token"];
    }
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
	@weakify(self);
	
	return [[[[[self rac_POST:@"oauth2/token" parameters:@{	@"grant_type"	: @"password",
															@"username"		: username,
															@"password"		: password,
															@"client_secret": SBClientSecret,
															@"client_id"		: SBClientID,
															@"include_user" : @"1",
															@"include_admin_accounts" : @"1"}]
				doNext:^(NSDictionary *response) {
				   @strongify(self);
				   
				   // set the auth token & auth state when a 'next' is sent
				   self.token = response[@"access_token"];
				   self.authenticated = YES;
			   	}]
				map:^id(NSDictionary *response) {
				   // deserialize the user
				   SBUser *user = [MTLJSONAdapter modelOfClass:[SBUser class]
											fromJSONDictionary:response[@"data"][@"user"]
														 error:nil];
				   user.adminAccounts = [MTLJSONAdapter
										 modelsOfClass:[SBAccount class]
										 fromJSONArray:response[@"data"][@"admin_accounts"]
										 error:nil];
				   
				   return user;
			   	}]
				doNext:^(SBUser *user) {
				  @strongify(self);
				  
				  // set the currently authenticated user
				  self.user = user;
			  	}]
			 	setNameWithFormat:@"Log In (username: %@, password: %@)", username, password];
}

- (RACSignal *)signUpWithEmail:(NSString *)email
					  password:(NSString *)password
					 birthDate:(NSDate *)birthDate {
	NSParameterAssert(email);
	NSParameterAssert(password);
	NSParameterAssert(birthDate);
    
	return [RACSignal error:nil];
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
					
					// on 'next', update the current user
					self.user = user;
				}]
				setNameWithFormat:@"Get \"me\""];
}

- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID forAccountWithID:(NSNumber *)accountID {
	return [[[self rac_GET:[NSString stringWithFormat:@"/v1/account/%d/audio/%d", accountID.intValue, audioID.intValue] parameters:nil]
				map:^id(NSDictionary *response) {
					return response;
				}]
				setNameWithFormat:@"Get audio track (accountID: %d, audioID: %d)", accountID.intValue, audioID.intValue];
}

- (RACSignal *)getUserWithID:(NSNumber *)userID {
	return [[[self rac_GET:[NSString stringWithFormat:@"users/%d", userID.intValue] parameters:nil]
				map:^id(NSDictionary *response) {
					return response;
				}]
				setNameWithFormat:@"Get user with ID: %d", userID.intValue];
}

- (RACSignal *)uploadAudioData:(NSData *)data
					 withTitle:(NSString *)title
			   toAccountWithID:(NSNumber *)accountID
				progressSignal:(RACSignal **)progressSignal {
	NSParameterAssert(data);
	NSParameterAssert(title);
	NSParameterAssert(accountID);
	
	NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%d/audio", accountID.intValue]].absoluteString;
	//
//	NSError *err;
//	NSMutableURLRequest *req =
//	[self.requestSerializer multipartFormRequestWithMethod:@"POST"
//												 URLString:endpointLocation
//												parameters:@{@"title" : title}
//								 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//									 [formData appendPartWithFileData:<#(NSData *)#> name:<#(NSString *)#> fileName:<#(NSString *)#> mimeType:<#(NSString *)#>
//									 if (err) {
//										 [subscriber sendError:err];
//									 }
//								 } error:&err];
//	
//	op = [self.api HTTPRequestOperationWithRequest:req success:nil failure:nil];
//	
//	if (signal) {
//		[op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//			[subj sendNext:@((double)totalBytesWritten * 100 / totalBytesExpectedToWrite)];
//			
//#ifdef DEBUG
//			NSLog(@"totalBytesWritten: %lld, totalBytesExpectedToWrite: %lld", totalBytesWritten, totalBytesExpectedToWrite);
//#endif
//			if (totalBytesWritten >= totalBytesExpectedToWrite) {
//#ifdef DEBUG
//				NSLog(@"done uploading. waiting for stagebloc to process...");
//#endif
//				
//				[subj sendCompleted];
//			}
//		}];
//	}
//	
	return [RACSignal empty];
}

- (RACSignal *)createFanClubForAccountWithID:(NSNumber *)accountID
									   title:(NSString *)title
								 description:(NSString *)description
									tierInfo:(NSDictionary *)tierInfo {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    if (title.length > 0) {
        params[@"title"] = title;
    }
    if (description.length > 0) {
        params[@"description"] = description;
    }
    if (tierInfo) {
        params[@"tier_info"] = tierInfo;
    }
    params[@"expand"] = @"account,photo";
    
    return [self rac_POST:[NSString stringWithFormat:@"account/%d/fanclub", accountID.intValue] parameters:params];
}

- (RACSignal *)getContentFromFanClubWithParentAccountID:(NSNumber *)accountID
												  limit:(NSUInteger)limit
												 offset:(NSUInteger)offset
								   additionalParameters:(NSDictionary *)parameters {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:(4 + parameters.count)];
    if (limit > 0) {
        params[@"limit"] = @(limit).stringValue;
    }
    if (offset) {
        params[@"offset"] = @(offset).stringValue;
    }
    params[@"expand"] = @"user,photo";
    if (parameters) {
        [params addEntriesFromDictionary:parameters];
    }
	params[@"filter"] = @"blog,photos,statuses";
    
    return [self rac_GET:[NSString stringWithFormat:@"account/%d/fanclub/content", accountID.intValue] parameters:params];
}

- (RACSignal *)getRecentFanClubContentWithLimit:(NSUInteger)limit
										 offset:(NSUInteger)offset
						   additionalParameters:(NSDictionary *)parameters {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    if (limit) {
        params[@"limit"] = [NSString stringWithFormat:@"%ld", (long)limit];
    }
    if (offset) {
        params[@"offset"] = [NSString stringWithFormat:@"%ld", (long)offset];
    }
    params[@"expand"] = @"user,account,photo";
	
    return [self rac_GET:@"account/fanclubs/following/content" parameters:params];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
	return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
}

@end
