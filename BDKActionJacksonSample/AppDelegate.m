//
//  AppDelegate.m
//  Created by Benjamin Kreeger on 1/25/13.
//

#import "AppDelegate.h"

#import "BDKViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[BDKViewController alloc] init];
    self.viewController.wantsFullScreenLayout = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
