//
//  SBModifiableContent.h
//  CocoaBloc
//
//  Created by Dan Zimmerman on 2/29/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

#import "SBContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBModifiableContent : SBContent

@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSNumber *isExclusive;

@end

NS_ASSUME_NONNULL_END
