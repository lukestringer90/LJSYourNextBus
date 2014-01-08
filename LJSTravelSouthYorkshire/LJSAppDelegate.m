//
//  LJSAppDelegate.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSAppDelegate.h"
#import "LJSTravelSouthYorkshire.h"

@implementation LJSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self main];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)main {
    LJSTravelSouthYorkshire *client = [[LJSTravelSouthYorkshire alloc] init];
    [client depatureDataForStopNumber:@"37090168" completion:^(id json, NSURL *nextPageURL, NSError *error) {
       NSLog(@"%@", json);
        NSLog(@"%@", error);
    }];
}

@end
