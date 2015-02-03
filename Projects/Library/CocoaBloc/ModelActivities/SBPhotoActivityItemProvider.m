//
//  SBPhotoActivityItemProvider.m
//  Pods
//
//  Created by John Heaton on 2/3/15.
//
//

#import "SBPhotoActivityItemProvider.h"
#import "SBDeleteActivity.h"
#import "SBFlagActivity.h"

@implementation SBPhotoActivityItemProvider

- (instancetype)initWithPhoto:(SBPhoto *)photo URLToFetch:(NSURL *)photoURL {
    if(!(self = [super initWithPlaceholderItem:[UIImage new]])) {
        _photo = photo;
        _photoURL = photoURL;
    }
    
    return self;
}

- (id)item {
    if ([self.activityType isEqualToString:SBDeleteActivityType] ||
        [self.activityType isEqualToString:SBFlagActivityType]) {
        return self.photo;
    }
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
}

@end
