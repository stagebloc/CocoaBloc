//
//  AppDelegate.m
//  CB Test App
//
//  Created by John Heaton on 9/4/14.
//  Copyright (c) 2014 StageBloc. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaBloc/SBAuthenticationViewController.h>
#import <CocoaBloc.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    SBAuthenticationViewController *vc;
}
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    [SBClient setClientID:@"de4346e640860eb3d6fd97e11e475d0d" clientSecret:@"c2288f625407c5aff55e41d1fef1ed73" redirectURI:@"theseboots://"];
    
    vc = [SBAuthenticationViewController new];
    [[vc presentFromParent:self.window.rootViewController] subscribeNext:^(id x) {
        NSLog(@"win %@", x);
    } error:^(NSError *error) {
        NSLog(@"err %@", error);
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
