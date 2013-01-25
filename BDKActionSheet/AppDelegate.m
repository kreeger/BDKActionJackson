//
//  AppDelegate.m
//  BDKActionSheet
//
//  Created by Benjamin Kreeger on 1/25/13.
//  Copyright (c) 2013 Ben Kreeger. All rights reserved.
//

#import "AppDelegate.h"

#import "BDKViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[BDKViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
