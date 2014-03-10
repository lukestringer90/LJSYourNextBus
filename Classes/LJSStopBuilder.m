//
//  LJSStopBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStopBuilder.h"
#import "LJSStop.h"

@implementation LJSStopBuilder

- (LJSStop *)stop {
    return [[LJSStop alloc] init];
}

@end

@interface LJSStop () {
    NSString *_NaPTANCode;
    NSString *_title;
    NSDate *_liveDate;
    NSArray *_services;
    
}
@end

@implementation LJSStop (LJSBuilderAdditions)

- (LJSStop *)withNaPTANCode:(NSString *)NaPTANCode {
    _NaPTANCode = NaPTANCode;
    return self;
}

- (LJSStop *)withTitle:(NSString *)title {
    _title = title;
    return self;
}

- (LJSStop *)withLiveDate:(NSDate *)scrapeDate {
    _liveDate = scrapeDate;
    return self;
}

- (LJSStop *)withServices:(NSArray *)services {
    _services = services;
    return self;
}

@end