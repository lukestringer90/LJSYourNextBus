//
//  LJSAppDelegate.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSAppDelegate.h"
#import "LJSNaPTANEntryViewController.h"

@implementation LJSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	LJSNaPTANEntryViewController *viewController = [[LJSNaPTANEntryViewController alloc] init];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
