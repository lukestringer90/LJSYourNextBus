//
//  LJSScraper.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LJSNaPTANCodeKey;
extern NSString * const LJSStopNameKey;
extern NSString * const LJSDepaturesKey;
extern NSString * const LJSDestinationKey;
extern NSString * const LJSExpectedDepatureTimeKey;
extern NSString * const LJSLiveDateKey;

@interface LJSScraper : NSObject

- (NSDictionary *)scrapeDepatureDataFromHTML:(NSString *)html;

- (NSURL *)scrapeNextPageURLFromHTML:(NSString *)html;

@end
