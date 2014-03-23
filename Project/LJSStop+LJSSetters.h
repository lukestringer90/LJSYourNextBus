//
//  LJSStop+LJSSetters.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStop.h"

@interface LJSStop (LJSSetters)

- (void)setNaPTANCode:(NSString *)NaPTANCode;
- (void)setTitle:(NSString *)title;
- (void)setLiveDate:(NSDate *)liveDate;
- (void)setServices:(NSArray *)services;
- (void)setLaterURL:(NSURL *)laterURL;
- (void)setEarlierURL:(NSURL *)earlier;

@end

