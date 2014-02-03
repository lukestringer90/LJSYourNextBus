//
//  LJSStopBuilder.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStopBuilder.h"

@implementation LJSStopBuilder

- (LJSStop *)stop {
    return [[LJSStop alloc] init];
}

@end

@interface LJSStop ()
@property (nonatomic, strong, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSDate *liveDate;
@property (nonatomic, strong, readwrite) NSArray *services;
@end

@implementation LJSStop (LJSBuilderAdditions)

- (LJSStop *)withNaPTANCode:(NSString *)NaPTANCode {
    self.NaPTANCode = NaPTANCode;
    return self;
}

- (LJSStop *)withTitle:(NSString *)title {
    self.title = title;
    return self;
}

- (LJSStop *)withLiveDate:(NSDate *)scrapeDate {
    self.liveDate = scrapeDate;
    return self;
}

- (LJSStop *)withServices:(NSArray *)services {
    self.services = services;
    return self;
}

@end