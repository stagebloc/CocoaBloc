//
//  NSObject+AssociatedObjects.h
//  CocoaBloc
//
//  Created by John Heaton on 9/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (AssociatedObjects)

- (void)setAssociatedObject:(id)object forKey:(NSString *)key policy:(objc_AssociationPolicy)policy;
- (id)associatedObjectForKey:(NSString *)key;
- (void)removeAssociatedObjectForKey:(NSString *)key;

@end
