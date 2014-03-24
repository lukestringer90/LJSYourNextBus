//
//  LJSDepartureDateParserTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "LJSDepartureDateParser.h"


@interface LJSDepartureDateParserTests : XCTestCase
@property (nonatomic, strong) LJSDepartureDateParser *dateParser;
@end

@implementation LJSDepartureDateParserTests

- (void)setUp {
	[super setUp];
	self.dateParser = [[LJSDepartureDateParser alloc] init];
}

- (void)testMinutesSingleDigit {
	NSString *string = @"2 mins";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSInteger timeIntervalDifference = [departureDate timeIntervalSince1970] - [baseDate timeIntervalSince1970];

	assertThatInteger(timeIntervalDifference, equalToInteger(2 * 60));
}

- (void)testMinutesDoubleDigit {
	NSString *string = @"61 mins";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSInteger timeIntervalDifference = [departureDate timeIntervalSince1970] - [baseDate timeIntervalSince1970];
	
	assertThatInteger(timeIntervalDifference, equalToInteger(61 * 60));
}

- (void)testHoursMinutes {
    NSString *string = @"17:20";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMinute | NSCalendarUnitHour
												   fromDate:departureDate];
	
	
	assertThatInteger(dateComponents.hour, equalToInteger(17));
	assertThatInteger(dateComponents.minute, equalToInteger(20));
}

@end
