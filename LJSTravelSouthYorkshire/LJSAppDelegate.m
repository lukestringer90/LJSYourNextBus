//
//  LJSAppDelegate.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSAppDelegate.h"
#import "LJSTravelSouthYorkshire.h"

// Helper function to see if we are running the production target or the test target
static BOOL isRunningTests(void) __attribute__((const));
static BOOL isRunningTests(void) {
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"xctest"];
}

@implementation LJSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (isRunningTests()) {
        return YES;
    }
    
    [self main];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)main {
    LJSTravelSouthYorkshire *client = [[LJSTravelSouthYorkshire alloc] init];
    [client depatureDataForNaPTANCode:@"37090168" completion:^(id json, NSURL *nextPageURL, NSError *error) {
       NSLog(@"%@", json);
        NSLog(@"%@", error);
    }];
}

@end
