//
//  LJSScraper.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSStop;
@interface LJSScraper : NSObject

- (BOOL)htmlIsValid:(NSString *)html;
- (BOOL)htmlContainsLiveData:(NSString *)html;
- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html;
- (NSArray *)scrapeMessagesFromHTML:(NSString *)html;

@end
