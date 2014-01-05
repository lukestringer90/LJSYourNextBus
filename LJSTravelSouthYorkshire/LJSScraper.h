//
//  LJSScraper.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LJSStopCodeKey;
extern NSString * const LJSSopNameKey;
extern NSString * const LJSDepaturesKey;
extern NSString * const LJSDestinationKey;
extern NSString * const LJSExpectedDepatureTime;

@class OGNode;

@interface LJSScraper : NSObject

- (instancetype)initWithHTMLString:(NSString *)htmlString;

- (NSDictionary *)scrapeDepatureData;

- (NSURL *)scrapeNextPageURL;

@end
