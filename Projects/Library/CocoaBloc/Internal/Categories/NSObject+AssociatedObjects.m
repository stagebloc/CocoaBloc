//
//  NSObject+AssociatedObjects.m
//  CocoaBloc
//
//  Created by John Heaton on 9/9/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "NSObject+AssociatedObjects.h"

@implementation NSObject (AssociatedObjects)

- (void)setAssociatedObject:(id)object forKey:(NSString *)key policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, policy);
}

- (id)associatedObjectForKey:(NSString *)key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)removeAssociatedObjectForKey:(NSString *)key {
    [self setAssociatedObject:nil forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}

@end
