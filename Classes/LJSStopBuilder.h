//
//  LJSStopBuilder.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSStop.h"

@interface LJSStopBuilder : NSObject

- (LJSStop *)stop;

@end

@interface LJSStop (LJSBuilderAdditions)

- (LJSStop *)withNaPTANCode:(NSString *)NaPTANCode;
- (LJSStop *)withTitle:(NSString *)title;
- (LJSStop *)withLiveDate:(NSDate *)scrapeDate;
- (LJSStop *)withServices:(NSArray *)services;

@end
