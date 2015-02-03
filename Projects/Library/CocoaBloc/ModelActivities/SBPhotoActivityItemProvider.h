//
//  SBPhotoActivityItemProvider.h
//  Pods
//
//  Created by John Heaton on 2/3/15.
//
//

#import <UIKit/UIKit.h>
#import "SBPhoto.h"

@interface SBPhotoActivityItemProvider : UIActivityItemProvider

- (instancetype)initWithPhoto:(SBPhoto *)photo URLToFetch:(NSURL *)photoURL;

@property (nonatomic) SBPhoto *photo;
@property (nonatomic) NSURL *photoURL;

@end
