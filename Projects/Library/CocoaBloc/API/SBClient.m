//
//  SBClient.m
//  CocoaBloc
//
//  Created by John Heaton on 7/16/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "SBClient.h"
#import "SBAudioUpload.h"

#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>

NSString *SBAPIMethodParameterResultLimit = @"limit";
NSString *SBAPIMethodParameterResultOffset = @"offset";

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
    if (!SBClientID.length || !SBClientSecret.length) {
        [NSException raise:@"CocoaBlocMissingClientIDSecretException" format:@"You may not use SBClient until you have set the current app's client id/secret with +[SBClient setClientID:clientSecret:]"];
        return nil;
    }
    
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

- (RACSignal *)getAudioTrackWithID:(NSNumber *)audioID forAccount:(SBAccount *)account {
    return [[[self rac_GET:[NSString stringWithFormat:@"/v1/account/%d/audio/%d", account.identifier.intValue, audioID.intValue] parameters:nil]
             	map:^id(NSDictionary *response) {
                 	return [MTLJSONAdapter modelOfClass:[SBAudioUpload class] fromJSONDictionary:response[@"data"] error:nil];
             	}]
            	setNameWithFormat:@"Get audio track (accountID: %d, audioID: %d)", account.identifier.intValue, audioID.intValue];
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

// Figure out MIME type based on extension
static inline NSString * SBContentTypeForPathExtension(NSString *extension, BOOL *supportedAudioUpload) {
    static NSArray *supportedAudioExtensions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        supportedAudioExtensions = @[@"aif", @"aiff", @"wav", @"m4a"];
    });
    
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    
    if (supportedAudioUpload) {
        *supportedAudioUpload = contentType != nil;
    }
    
    return contentType;
}

- (RACSignal *)uploadAudioData:(NSData *)data
                     withTitle:(NSString *)title
                      fileName:(NSString *)fileName
                     toAccount:(SBAccount *)account
                progressSignal:(RACSignal **)progressSignal {
    NSParameterAssert(data);
    NSParameterAssert(title);
    NSParameterAssert(fileName);
    NSParameterAssert(account);
    
    // create endpoint location string
    NSString *endpointLocation = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"account/%d/audio", account.identifier.intValue]].absoluteString;
    
    // verify that the mime type is valid and supported by us
    BOOL supported;
    NSString *mime = SBContentTypeForPathExtension([fileName.lastPathComponent componentsSeparatedByString:@"."].lastObject, &supported);
    
    if (!supported || !mime) {
#warning make this a real error
        return [RACSignal error:[NSError errorWithDomain:@"temp" code:1 userInfo:nil]];
    }
    
    // create the upload request
    NSError *err;
    NSMutableURLRequest *req =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:endpointLocation
                                                parameters:@{@"title" : title}
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                     [formData appendPartWithFileData:data name:@"audio" fileName:fileName mimeType:mime];
                                 } error:&err];
    
    if (err) {
        return [RACSignal error:err];
    }
    
    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:req success:nil failure:nil];
    if (progressSignal) {
        
        // progress signal is still cold. beautiful!
        *progressSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                [subscriber sendNext:@((double)totalBytesWritten * 100 / totalBytesExpectedToWrite)];
                
                if (totalBytesWritten >= totalBytesExpectedToWrite) {
                    [subscriber sendCompleted];
                }
            }];
            
            return [RACDisposable disposableWithBlock:^{
                [op setUploadProgressBlock:nil];
            }];
        }];
        
    }
    
    // use defer to turn "hot" enqueueing into cold signal
    return [RACSignal defer:^RACSignal *{
        return [[self rac_enqueueHTTPRequestOperation:op]
                	map:^id(NSDictionary *response) {
                    	return [MTLJSONAdapter modelOfClass:[SBAudioUpload class]
                                         fromJSONDictionary:response[@"data"]
                                                      error:nil];
                    }];
    }];
}

- (RACSignal *)createFanClubForAccount:(SBAccount *)account
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
    
    return [self rac_POST:[NSString stringWithFormat:@"account/%d/fanclub", account.identifier.intValue] parameters:params];
}

- (RACSignal *)getContentFromFanClubForAccount:(SBAccount *)account
									parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:(4 + parameters.count)];
    
    params[@"expand"] = @"user,photo";
    [params addEntriesFromDictionary:parameters];
    params[@"filter"] = @"blog,photos,statuses";
    
    return [self rac_GET:[NSString stringWithFormat:@"account/%d/fanclub/content", account.identifier.intValue] parameters:params];
}

- (RACSignal *)getRecentFanClubContentWithParameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2 + 2 * parameters.count];
    
    [params addEntriesFromDictionary:parameters];
    params[@"expand"] = @"user,account,photo";
    
    return [self rac_GET:@"account/fanclubs/following/content" parameters:params];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
    return [self rac_enqueueHTTPRequestOperation:[self HTTPRequestOperationWithRequest:request success:nil failure:nil]];
}

@end
