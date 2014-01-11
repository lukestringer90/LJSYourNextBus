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
    NSString *NaPTANCode = @"37021865";
    
    LJSTravelSouthYorkshire *client = [[LJSTravelSouthYorkshire alloc] init];
    [client depatureDataForNaPTANCode:NaPTANCode completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
        NSLog(@"%@", depatureData);
        NSLog(@"%@", error);
        
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:depatureData
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&jsonError];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
        }
        
    }];
}

@end
