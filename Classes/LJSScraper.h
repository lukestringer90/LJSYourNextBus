//
//  LJSScraper.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSStop;
@interface LJSScraper : NSObject

- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html;

- (NSDictionary *)scrapeDepatureDataFromHTML:(NSString *)html;
- (NSURL *)scrapeLaterDepaturesURL:(NSString *)html;
- (NSURL *)scrapeEarlierDepaturesURL:(NSString *)html;

@end
