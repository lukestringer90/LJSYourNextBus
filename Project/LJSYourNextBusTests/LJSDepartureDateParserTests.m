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

- (void)testDateStringMinutesSingleDigit {
	NSString *string = @"2 mins";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSInteger timeIntervalDifference = [departureDate timeIntervalSince1970] - [baseDate timeIntervalSince1970];

	assertThatInteger(timeIntervalDifference, equalToInteger(2 * 60));
}

- (void)testDateStringMinutesDoubleDigit {
	NSString *string = @"61 mins";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSInteger timeIntervalDifference = [departureDate timeIntervalSince1970] - [baseDate timeIntervalSince1970];
	
	assertThatInteger(timeIntervalDifference, equalToInteger(61 * 60));
}

- (void)testDateStringHoursMinutes {
    NSString *string = @"17:20";
	NSDate *baseDate = [NSDate date];
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMinute | NSCalendarUnitHour
												   fromDate:departureDate];
	
	
	assertThatInteger(dateComponents.hour, equalToInteger(17));
	assertThatInteger(dateComponents.minute, equalToInteger(20));
}

- (void)testMinutesUntilDateZeroMinutes {
    // 24.03.2014 10:56:00
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395658560];
	NSString *departureDateString = @"10:56";
	
	NSInteger minutes = [self.dateParser minutesUntilDate:date departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(0));
}

- (void)testMinutesUntilDate1Minute {
    //  24.03.2014 10:56:00
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395658560];
	NSString *departureDateString = @"10:57";
	
	NSInteger minutes = [self.dateParser minutesUntilDate:date departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(1));
}

- (void)testMinutesUntilDate2Minutes {
    // 24.03.2014 10:56:00
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395658560];
	NSString *departureDateString = @"10:58";
	
	NSInteger minutes = [self.dateParser minutesUntilDate:date departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(2));
}

- (void)testMinutesUntilDate10Minutes {
    // 24.03.2014 10:56:00
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395658560];
	NSString *departureDateString = @"11:06";
	
	NSInteger minutes = [self.dateParser minutesUntilDate:date departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(10));
}

- (void)testMinutesUntilDate60Minutes {
    // 24.03.2014 10:56:00
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395658560];
	NSString *departureDateString = @"11:56";
	
	NSInteger minutes = [self.dateParser minutesUntilDate:date departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(60));
}

@end
