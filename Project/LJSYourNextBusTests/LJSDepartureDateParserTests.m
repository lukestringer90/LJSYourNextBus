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
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) NSCalendarUnit allCalendarUnits;
@end

@implementation LJSDepartureDateParserTests

- (void)setUp {
	[super setUp];
	self.dateParser = [[LJSDepartureDateParser alloc] init];
	self.calendar = [NSCalendar currentCalendar];
	self.allCalendarUnits = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
}

#pragma mark - Testing dateFromString:baseDate

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

- (void)testDateStringMinutesTomorrow {
	NSString *string = @"20 mins";
    NSDate *baseDate = [NSDate dateWithTimeIntervalSince1970:1388533800];	// 31.12.2013 23:50:00
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	
	NSDateComponents *dateComponents = [self.calendar components:self.allCalendarUnits
														fromDate:departureDate];
	
	
	assertThatInteger(dateComponents.minute, equalToInteger(10));
	assertThatInteger(dateComponents.hour, equalToInteger(0));
	assertThatInteger(dateComponents.day, equalToInteger(1));
	assertThatInteger(dateComponents.month, equalToInteger(1));
	assertThatInteger(dateComponents.year, equalToInteger(2014));
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

- (void)testDateStringHoursMinutesTomorrow {
	NSString *string = @"01:35";
	NSDate *baseDate = [NSDate dateWithTimeIntervalSince1970:1388533800];	// 31.12.2013 23:50:00
	NSDate *departureDate = [self.dateParser dateFromString:string baseDate:baseDate];
	
	
	NSDateComponents *dateComponents = [self.calendar components:self.allCalendarUnits
														fromDate:departureDate];
	
	
	assertThatInteger(dateComponents.minute, equalToInteger(35));
	assertThatInteger(dateComponents.hour, equalToInteger(1));
	assertThatInteger(dateComponents.day, equalToInteger(1));
	assertThatInteger(dateComponents.month, equalToInteger(1));
	assertThatInteger(dateComponents.year, equalToInteger(2014));
}


#pragma mark - Testing minutesUntilDate:departureDateString

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

- (void)testMinutesTomorrow {
    NSString *departureDateString = @"00:20";
	NSDate *baseDate = [NSDate dateWithTimeIntervalSince1970:1388533800];	// 31.12.2013 23:50:00
	
	NSInteger minutes = [self.dateParser minutesUntilDate:baseDate departureDateString:departureDateString];
	
	assertThatInteger(minutes, equalToInteger(30));
}

@end
