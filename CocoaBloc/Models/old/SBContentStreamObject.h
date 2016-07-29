//
//  SBContentStreamObject.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 3/2/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

#import "SBObject.h"

@class SBAccount;

NS_ASSUME_NONNULL_BEGIN

@interface SBContentStreamObject : SBObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, nullable) NSDate *initialDate;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *accountID;

// This will be nil if +[NSURL URLWithString:] fails
@property (nonatomic, nullable) NSURL *shortURL;
@property (nonatomic, nullable) NSNumber *userHasLiked;
@property (nonatomic, nullable) SBAccount *account;

@end

NS_ASSUME_NONNULL_END
